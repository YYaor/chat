//
//  LSTabBarController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSTabBarController.h"

#import "LSWorkController.h"
#import "LSMessageController.h"
#import "LSManageController.h"
#import "LSMineController.h"

@interface LSTabBarController ()

@end

@implementation LSTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    [UINavigationBar appearance].backgroundColor = [UIColor colorFromHexString:@"B3EE3A"];
    [UINavigationBar appearance].barTintColor = [UIColor colorFromHexString:@"B3EE3A"];
    [UINavigationBar appearance].tintColor = [UIColor colorFromHexString:@"FFFFFF"];
    // hide title of back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [UITabBar appearance].tintColor = [UIColor colorFromHexString:@"B3EE3A"];
    
    NSArray *title = @[@"工作台", @"消息", @"患者管理", @"我的"];
    NSArray *defaultImage = @[@"", @"", @"", @""];
    NSArray *selectedImage = @[@"", @"", @"", @""];
    
    self.viewControllers = @[
                             [[UINavigationController alloc] initWithRootViewController:[[LSWorkController alloc] initWithNibName:@"LSWorkController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSMessageController alloc] initWithNibName:@"LSMessageController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSManageController alloc] initWithNibName:@"LSManageController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSMineController alloc] initWithNibName:@"LSMineController" bundle:nil]],
                             ];
    
    for (NSInteger i=0; i<self.viewControllers.count; i++)
    {
        UINavigationController *nav = self.viewControllers[i];
        nav.tabBarItem.title = title[i];
//        self.tabBarItem.image = [[UIImage imageNamed:defaultImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        self.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    self.selectedIndex = 0;
    
}

@end
