//
//  AppDelegate.m
//  PushBoxSDKExample
//
//  Created by Gert Lavsen on 01/12/15.
//  Copyright © 2015 House of Code. All rights reserved.
//

#import "AppDelegate.h"
#import <pushbox-sdk-ios/HoCPushBoxSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 1) Set the api key and secret
    [HoCPushBoxSDK setApiKey:@"<PUT API KEY HERE>" andSecret:@"<PUT API SECRET HERE>"];
    [HoCPushBoxSDK setVerbosity:HoCPushBoxVerbosityDebug];
    // 2) Register a payload handler
    [[HoCPushBoxSDK sharedInstance] registerPayloadHandler:^(HoCPushMessage *message) {
        // Decide what to do when a message is received from PushBox
        // This can be added where ever wanted, but the handler has to be retained
        NSString *msg = [NSString stringWithFormat:@"Message: %@, Payload: %@", message.message, message.payload];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message.title message:msg delegate:nil cancelButtonTitle:@"OK - got it" otherButtonTitles:nil];
        [alert show];
    }];
    
    // 3) Setup push notifications
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // iOS 8 and prior
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // Register for Push Notifications, if running iOS version < 8
        // Deprecated
        // Optional part - only used if targeting below iOS version 8.
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    // 4) Handle launch options to see if app is launched from a push message
    [[HoCPushBoxSDK sharedInstance] handleLaunchingWithOptions:launchOptions];
    
    
    // 5) Example of logging an event
    [[HoCPushBoxSDK sharedInstance] logEvent:@"opened app"];
    
    // 6) Example of setting the age of the user
    [[HoCPushBoxSDK sharedInstance] setAge:22];
    
    // 7) Example of setting channels for the user
    [[HoCPushBoxSDK sharedInstance] setChannels:@[@"cars", @"electronics", @"hair products"]];
    return YES;
}

// 8) Implement did register for remote notifications with device token
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"Did register for notes: %@", deviceToken);
    // 9) Inform the sdk about the token
    [[HoCPushBoxSDK sharedInstance] setDeviceToken:deviceToken];
}

// 10) Implement this method to get informed if remote notification registering failed. Optional
-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

// 11) Implement the did receive remote notification to handle when a push message is recevied when app is running. Required
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Did receive remote notification: %@", userInfo);
    // 12) Inform the sdk that a message is received
    [[HoCPushBoxSDK sharedInstance] handleRemoteNotification:userInfo];
}
@end
