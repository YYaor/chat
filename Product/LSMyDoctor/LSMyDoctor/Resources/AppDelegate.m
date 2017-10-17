//
//  AppDelegate.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "AppDelegate.h"

#import "LSTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册环信会话
//    EMOptions *options = [EMOptions optionsWithAppkey:@"1186170929115740#youge"];
//    options.apnsCertName = @"PengGe_Doctor_p12";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    LSTabBarController *tabController = [[LSTabBarController alloc] init];
    self.window.rootViewController = tabController;
    
    /**
     *  环信
     */
    EMOptions *options = [EMOptions optionsWithAppkey:@"1186170929115740#youge"];
    options.apnsCertName = @"MyDoctor_Dev_Apns";
    [[EMClient sharedClient] initializeSDKWithOptions:options];

    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:@"1186170929115740#youge"
                                         apnsCertName:@"release"
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [self loginIM];
    
    return YES;
}

-(BOOL)loginIM{
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:@"zjc123"
                                                           password:@"zjc123"];
        if (!error)
        {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        } else {
            NSLog(@"环信登录失败");
        }
    }
    
    [self asyncGroupFromServer];
    
    return isAutoLogin;
}

- (void)asyncGroupFromServer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:nil pageSize:0 error:&error];
        if (!error) {
            
        }
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //环信调用App进入后台
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken :%@",deviceToken);
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //环信调用  App从后台返回
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
