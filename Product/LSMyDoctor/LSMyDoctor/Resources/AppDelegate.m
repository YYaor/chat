//
//  AppDelegate.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "AppDelegate.h"

#import "LSTabBarController.h"
#import "LSLoginController.h"
#import "SplashViewController.h"

#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册环信会话
    //    EMOptions *options = [EMOptions optionsWithAppkey:@"1186170929115740#youge"];
    //    options.apnsCertName = @"PengGe_Doctor_p12";
    //    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [NSThread sleepForTimeInterval:3.0];
    //设置键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
    
    /**
     *  环信
     */
    EMOptions *options = [EMOptions optionsWithAppkey:@"1186170929115740#youge"];
    options.apnsCertName = @"MyDoctor_Dev_Apns";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:@"1186170929115740#youge"
                                         apnsCertName:@"MyDoctor_Dev_Apns"
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [self loginIM];
    //获取token
    [self initAccessToken];
    
//    [self intoRootForLogin];
    
    return YES;
}

-(BOOL)loginIM{
    if (![[Defaults objectForKey:@"isLogin"] boolValue]) {
        return NO;
    }
    NSString *doctorId = [Defaults objectForKey:@"doctorid"];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"ug369D%@",doctorId]
                                                           password:@"000000"];
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
#pragma mark -- 获取token
- (void)initAccessToken
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSString* headUrl = [API_HOST substringToIndex:API_HOST.length - 3];
    NSString* tokenUrl = [NSString stringWithFormat:@"%@/home/getAccessTokenEx",headUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:tokenUrl parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"status"] integerValue] == 0) {
            
            [Defaults setValue:responseObject[@"data"] forKey:@"accessToken"];
            NSLog(@"*******token:%@*****",responseObject[@"data"]);
            [Defaults synchronize];
            
            //更改状态蓝颜色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.window.backgroundColor = [UIColor whiteColor];
            
            //启动引导页控制器
            SplashViewController *splashVC = [[SplashViewController alloc]init];
            self.window.rootViewController = splashVC;
            
            [self.window makeKeyAndVisible];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
    }];
}

#pragma mark - 跳转

- (void)intoRootForMain
{
    LSTabBarController *vc = [[LSTabBarController alloc] init];
    self.window.rootViewController = vc;
}

- (void)intoRootForLogin
{
    LSLoginController *vc = [[LSLoginController alloc] initWithNibName:@"LSLoginController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

@end
