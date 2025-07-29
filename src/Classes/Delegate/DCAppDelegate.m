//
//  DCAppDelegate.m
//  Discord Classic
//
//  Created by bag.xml on 3/2/18.
//  Copyright (c) 2018 bag.xml. All rights reserved.
//

#import "DCAppDelegate.h"
#include "SDWebImageManager.h"
#include <UIKit/UIKit.h>
#import "UIDeviceAdditions.h"
#import "DCServerCommunicator.h"
#import "DCUser.h"
#import "DCRole.h"

@interface DCAppDelegate ()
@property (assign, nonatomic) BOOL shouldReload;
@end

@implementation DCAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [NSTimer scheduledTimerWithTimeInterval:2.0
    //     target:[UIDevice currentDevice]
    //     selector:@selector(currentMemoryUsage)
    //     userInfo:nil
    //     repeats:YES];

    self.window.backgroundColor = [UIColor clearColor];
    self.window.opaque          = NO;
    self.shouldReload           = false;
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (VERSION_MIN(@"7.0")) {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"UIUseLegacyUI"];
    }
    // if(VERSION_MIN(@"7.0")) {
    /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iOS-7"
       bundle:nil]; UIViewController *initialViewController = [storyboard
       instantiateInitialViewController]; self.window.rootViewController =
       initialViewController; [self.window makeKeyAndVisible];*/

    //} else if(VERSION_MIN(@"6.0")) {
    self.experimental =
        [[NSUserDefaults standardUserDefaults] boolForKey:@"experimentalMode"];
    self.hackyMode =
        [[NSUserDefaults standardUserDefaults] boolForKey:@"hackyMode"];

    if (self.experimental && self.hackyMode) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hackyMode"];
    }

    if (self.experimental) {
        UIStoryboard *storyboard =
            [UIStoryboard storyboardWithName:@"Experimental"
                                      bundle:nil];
        UIViewController *initialViewController =
            [storyboard instantiateInitialViewController];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
    } else if (self.hackyMode) {
        UIStoryboard *storyboard =
            [UIStoryboard storyboardWithName:@"Throwback"
                                      bundle:nil];
        UIViewController *initialViewController =
            [storyboard instantiateInitialViewController];
        self.window.rootViewController = initialViewController;
        [self.window makeKeyAndVisible];
        [UINavigationBar.appearance
            setBackgroundImage:[UIImage imageNamed:@"OldTitlebarTexture"]
                 forBarMetrics:UIBarMetricsDefault];
    }

    //}

    NSURLCache *urlCache = [[NSURLCache alloc]
        initWithMemoryCapacity:1024 * 1024 * 8  // 8MB mem cache
                  diskCapacity:1024 * 1024 * 60 // 60MB disk cache
                      diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    application.applicationIconBadgeNumber = 0;

    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("dis.cord.Discord.badgeReset"), NULL, NULL, true
    );

    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary *aps          = notification[@"aps"];
        NSString *channelId        = aps[@"channelId"]; // Adjusted to reflect your payload structure
        // NSLog(@"Channel id: %@", channelId);
        if (channelId) {
            // NSLog(@"App launched with notification, channelId: %@",
            // channelId);
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(),
                ^{
                    [[NSNotificationCenter defaultCenter]
                        postNotificationName:@"NavigateToChannel"
                                      object:nil
                                    userInfo:@{@"channelId" : channelId}];
                }
            );
        }
    }

    if (DCServerCommunicator.sharedInstance.token.length) {
        [DCServerCommunicator.sharedInstance startCommunicator];
    }

    return YES;
}


- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // NSLog(@"RECEIVED REMOTE NOTIFICATION");

    NSDictionary *aps   = userInfo[@"aps"];
    NSString *channelId = aps[@"channelId"];
    // NSLog(@"Received notification with Channel id: %@", channelId);

    if (channelId) {
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateInactive
            || state == UIApplicationStateBackground) {
            // App was in the background or not running, meaning the user tapped
            // the notification
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"NavigateToChannel"
                                  object:nil
                                userInfo:@{@"channelId" : channelId}];
            });
        } else {
            // NSLog(@"FUCK YOU LJB I HATE YOU");
            // ok requis
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // NSLog(@"Will resign active");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // NSLog(@"Did enter background");
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.shouldReload = DCServerCommunicator.sharedInstance.didAuthenticate;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // NSLog(@"Will enter foreground");
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // NSLog(@"Did become active");
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.shouldReload) {
        [DCServerCommunicator.sharedInstance sendResume];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    // NSLog(@"Will terminate");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"Memory warning received, clearing image cache!");
    for (DCUser *user in DCServerCommunicator.sharedInstance.loadedUsers.allValues) {
        @autoreleasepool {
            user.profileImage = nil;
            user.avatarDecoration = nil;
        }
    }
    for (DCRole *role in DCServerCommunicator.sharedInstance.loadedRoles.allValues) {
        @autoreleasepool {
            role.icon = nil;
        }
    }
    // [[UIDevice currentDevice] currentMemoryUsage];
    [SDWebImageManager.sharedManager.imageCache clearMemory];
}

@end
