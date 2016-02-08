//
//  MHLoginSession.m
//  CoreHound
//
//  Copyright (c) 2015 MediaHound. All rights reserved.
//

#import "MHLoginSession.h"
#import "MHUser.h"
#import "MHFetcher.h"
#import "MHObject+Internal.h"
#import "MHError+Internal.h"
#import "MHSDK+Internal.h"
#import "MHFetcher.h"
#import "MHJSONResponseSerializerWithData.h"

#import <Avenue/AVENetworkManager.h>
//#import <AgnosticLogger/AgnosticLogger.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <AtSugar/AtSugar.h>

NSString* const MHLoginSessionUserDidLoginNotification = @"MHLoginSessionUserDidLoginNotification";
NSString* const MHLoginSessionUserDidLogoutNotification = @"MHLoginSessionUserDidLogoutNotification";

static NSString* const LoginKeychainKeyUsername = @"username";
static NSString* const LoginKeychainKeyPassword = @"password";
static NSString* const LoginKeychainKeyAccessToken = @"accessToken";

static MHLoginSession* s_currentSession = nil;


@interface MHLoginSession ()

@property (strong, nonatomic) NSArray* users;

@end


@implementation MHLoginSession

+ (NSString*)protocolForArrayProperty:(NSString*)propertyName
{
    if ([propertyName isEqualToString:NSStringFromSelector(@selector(users))]) {
        return NSStringFromClass(MHUser.class);
    }
    return [super protocolForArrayProperty:propertyName];
}

+ (instancetype)currentSession
{
    return s_currentSession;
}

+ (AnyPromise*)loginUsingSavedCredentials
{
    NSString* username = [UICKeyChainStore stringForKey:LoginKeychainKeyUsername];
    NSString* password = [UICKeyChainStore stringForKey:LoginKeychainKeyPassword];
    NSString* accessToken = [UICKeyChainStore stringForKey:LoginKeychainKeyAccessToken];
    if (username && password) {
        return [self loginWithUsername:username password:password];
    }
    else if (accessToken) {
        return [self loginWithAccessToken:accessToken];
    }
    else {
        return [AnyPromise promiseWithValue:MHErrorMake(MHLoginSessionNoSavedCredentialsError, @{})];
    }
}

+ (void)saveCredentialsWithUsername:(NSString*)username password:(NSString*)password
{
    [UICKeyChainStore setString:username forKey:LoginKeychainKeyUsername];
    [UICKeyChainStore setString:password forKey:LoginKeychainKeyPassword];
}

+ (void)removeCredentials
{
    [UICKeyChainStore removeItemForKey:LoginKeychainKeyUsername];
    [UICKeyChainStore removeItemForKey:LoginKeychainKeyPassword];
    [UICKeyChainStore removeItemForKey:LoginKeychainKeyAccessToken];
}

+ (void)saveAccessToken:(NSString*)accessToken
{
    [UICKeyChainStore setString:accessToken forKey:LoginKeychainKeyAccessToken];
}

+ (AnyPromise*)loginWithUsername:(NSString*)username
                     password:(NSString*)password
{
//    AGLLogVerbose(@"[MHLoginSession] Attempting Login");
    
    return [[AVENetworkManager sharedManager] POST:[MHUser rootSubendpoint:@"login"]
                                        parameters:@{
                                                     @"username": username,
                                                     @"password": password
                                                     }
                                          priority:nil
                                      networkToken:nil
                                           builder:[MHFetcher sharedFetcher].builder].thenInBackground(^id(NSDictionary* responseObject) {
        if ([responseObject[@"Error"] isEqualToString:@"Invalid Credentials"]) {
//            AGLLogInfo(@"[MHLoginSession] Login had invalid credentials");
            
            return MHErrorMake(MHLoginSessionInvalidCredentialsError, @{});
        }
        else {
//            AGLLogInfo(@"[MHLoginSession] Login request succesful. Now fetching user by mhid.");
            return [[MHFetcher sharedFetcher] fetchModel:MHLoginSession.class
                                                    path:[MHUser rootSubendpoint:@"validateSession"]
                                                 keyPath:nil
                                              parameters:@{
                                                           MHFetchParameterView: MHFetchParameterViewFull
                                                           }
                                                priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                                  postponeable:NO]
                                            networkToken:nil].thenInBackground(^(MHLoginSession* session) {
                s_currentSession = session;
                
                [self saveCredentialsWithUsername:username password:password];
                
//                AGLLogInfo(@"[MHLoginSession] Succesful login completed");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:MHLoginSessionUserDidLoginNotification
                                                                        object:self];
                });
                
                return session;
            });
        }
    }).catch(^(NSError* error) {
//        AGLLogError(@"[MHLoginSession] Failure to login: %@", error);
        return error;
    });
}

+ (NSURL*)loginDialogURLWithRedirectURL:(NSURL*)redirect
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@security/oauth/authorize?client_id=%@&client_secret=%@&scope=public_profile+user_follows+user_collections+user_actions.update_collection&response_type=token&redirect_uri=%@", [MHFetcher sharedFetcher].builder.baseURL.absoluteString, [MHSDK sharedSDK].clientId, [MHSDK sharedSDK].clientSecret, redirect.absoluteString]];
}

+ (AnyPromise*)loginWithAccessToken:(NSString*)accessToken
{
    AVEHTTPRequestOperationBuilder* mainBuilder = [MHFetcher sharedFetcher].builder;
    
    AVEHTTPRequestOperationBuilder* oauthBuilder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:mainBuilder.baseURL];
    
    oauthBuilder.requestSerializer = [AFHTTPRequestSerializer serializer];
    [oauthBuilder.requestSerializer setAuthorizationHeaderFieldWithUsername:[MHSDK sharedSDK].clientId
                                                                   password:[MHSDK sharedSDK].clientSecret];
    oauthBuilder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
    
    oauthBuilder.securityPolicy = mainBuilder.securityPolicy;
    
    
    return [[AVENetworkManager sharedManager] POST:@"security/oauth/check_token"
                                        parameters:@{
                                                     @"token": accessToken
                                                     }
                                          priority:nil
                                      networkToken:nil
                                           builder:oauthBuilder].then(^(NSDictionary* response) {
        [MHSDK sharedSDK].userAccessToken = accessToken;
        return [MHUser fetchByUsername:response[@"user_name"]];
    }).then(^(MHUser* user) {
        // Save AccessToken
        [self saveAccessToken:accessToken];
        
        // Make logged in user
        s_currentSession = [[MHLoginSession alloc] init];
        s_currentSession.users = @[user];
    
        // Dispatch logged in notification
        [[NSNotificationCenter defaultCenter] postNotificationName:MHLoginSessionUserDidLoginNotification
                                                            object:self];
        
        return user;
    });
}

- (MHUser*)user
{
    return self.users.firstObject;
}

- (void)logout
{
    [self.class removeCredentials];
    s_currentSession = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:MHLoginSessionUserDidLogoutNotification
                                                        object:self];
}

@end
