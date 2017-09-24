//
//  LSMineController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineController.h"

#import "LSPrefixHeader.h"

@interface LSMineController ()

@end

@implementation LSMineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor colorFromHexString:@"FFC125"];
}

@end
