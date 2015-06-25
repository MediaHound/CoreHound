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

#import <Avenue/AVENetworkManager.h>
//#import <AgnosticLogger/AgnosticLogger.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <AtSugar/AtSugar.h>

NSString* const MHLoginSessionUserDidLoginNotification = @"MHLoginSessionUserDidLoginNotification";
NSString* const MHLoginSessionUserDidLogoutNotification = @"MHLoginSessionUserDidLogoutNotification";

static NSString* const LoginKeychainKeyUsername = @"username";
static NSString* const LoginKeychainKeyPassword = @"password";

static MHLoginSession* s_currentSession = nil;


@interface MHLoginSession ()

@property (strong, nonatomic) NSArray<MHUser>* users;

@end


@implementation MHLoginSession

+ (instancetype)currentSession
{
    return s_currentSession;
}

+ (PMKPromise*)loginUsingSavedCredentials
{
    NSString* username = [UICKeyChainStore stringForKey:LoginKeychainKeyUsername];
    NSString* password = [UICKeyChainStore stringForKey:LoginKeychainKeyPassword];
    if (username && password) {
        return [self loginWithUsername:username password:password];
    }
    else {
        return [PMKPromise promiseWithValue:MHErrorMake(MHLoginSessionNoSavedCredentialsError, @{})];
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
}

+ (PMKPromise*)loginWithUsername:(NSString*)username
                     password:(NSString*)password
{
//    AGLLogVerbose(@"[MHLoginSession] Attempting Login");
    
    return [[AVENetworkManager sharedManager] POST:[MHUser rootSubendpoint:@"login"]
                                        parameters:@{
                                                     @"username": username,
                                                     @"password": password
                                                     }
                                          priority:[AVENetworkPriority priorityWithLevel:AVENetworkPriorityLevelHigh
                                                                            postponeable:NO]
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
