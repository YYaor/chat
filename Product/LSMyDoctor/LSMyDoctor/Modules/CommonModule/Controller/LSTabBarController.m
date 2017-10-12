//
//  LSTabBarController.m
//  LSMyDoctor
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
    [UINavigationBar appearance].backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
    [UINavigationBar appearance].barTintColor = [UIColor colorFromHexString:LSGREENCOLOR];
    [UINavigationBar appearance].tintColor = [UIColor colorFromHexString:@"FFFFFF"];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    // hide title of back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
    [UITabBar appearance].translucent = NO;
    
    NSArray *defaultImage = @[@"b_workstation", @"b_news", @"b_patientmanagement", @"b_mine"];
    NSArray *selectedImage = @[@"b_workstation_h", @"b_news_h", @"b_patientmanagement_h", @"b_mine_h"];
    
    self.viewControllers = @[
                             [[UINavigationController alloc] initWithRootViewController:[[LSWorkController alloc] initWithNibName:@"LSWorkController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSMessageController alloc] initWithNibName:@"LSMessageController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSManageController alloc] initWithNibName:@"LSManageController" bundle:nil]],
                             [[UINavigationController alloc] initWithRootViewController:[[LSMineController alloc] initWithNibName:@"LSMineController" bundle:nil]],
                             ];
    
    for (NSInteger i=0; i<self.viewControllers.count; i++)
    {
        UINavigationController *nav = self.viewControllers[i];
        nav.tabBarItem.image = [UIImage imageNamed:defaultImage[i]];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    self.selectedIndex = 0;
}

@end
