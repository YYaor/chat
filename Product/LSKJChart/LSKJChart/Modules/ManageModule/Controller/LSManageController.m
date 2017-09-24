//
//  LSManageController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageController.h"

#import "LSPrefixHeader.h"


@interface LSManageController ()

@end

@implementation LSManageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"患者管理";
    self.view.backgroundColor = [UIColor colorFromHexString:@"F0F8FF"];
}

@end
