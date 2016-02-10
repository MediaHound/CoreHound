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
    AVEHTTPRequestOperationBuilder* mainBuilder = [MHFetcher sharedFetcher].builder;
    
    AVEHTTPRequestOperationBuilder* oauthBuilder = [[AVEHTTPRequestOperationBuilder alloc] initWithBaseURL:mainBuilder.baseURL];
    
    oauthBuilder.requestSerializer = [AFHTTPRequestSerializer serializer];
    [oauthBuilder.requestSerializer setAuthorizationHeaderFieldWithUsername:[MHSDK sharedSDK].clientId
                                                                   password:[MHSDK sharedSDK].clientSecret];
    oauthBuilder.responseSerializer = [MHJSONResponseSerializerWithData serializer];
    
    oauthBuilder.securityPolicy = mainBuilder.securityPolicy;
    
    
    return [[AVENetworkManager sharedManager] POST:@"security/oauth/token"
                                        parameters:@{
                                                     @"username": username,
                                                     @"password": password,
                                                     @"client_id": [MHSDK sharedSDK].clientId,
                                                     @"client_secret": [MHSDK sharedSDK].clientSecret,
                                                     @"grant_type": @"password",
                                                     @"scope": @"public_profile+user_follows+user_likes+user_collections+user_actions.like+user_actions.follow+user_actions.post+user_actions.new_collection+user_actions.update_collection+user_feed+user_suggested"
                                                     }
                                          priority:nil
                                      networkToken:nil
                                           builder:oauthBuilder].then(^id(NSDictionary* response) {
        NSString* accessToken = response[@"access_token"];
        
        if (accessToken) {
            [MHSDK sharedSDK].userAccessToken = accessToken;
            return [MHUser fetchByUsername:username].then(^(MHUser* user) {
                // Save AccessToken
                [self saveCredentialsWithUsername:username password:password];
                
                // Make logged in user
                s_currentSession = [[MHLoginSession alloc] init];
                s_currentSession.users = @[user];
                
                // Dispatch logged in notification
                [[NSNotificationCenter defaultCenter] postNotificationName:MHLoginSessionUserDidLoginNotification
                                                                    object:self];
                
                return s_currentSession;
            });
        }
        else {
            return MHErrorMake(MHLoginSessionInvalidCredentialsError, @{});
        }
    }).catch(^(NSError* error) {
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
        
        return user; // TODO: This should return session
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
