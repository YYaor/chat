//
//  LSMessageController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMessageController.h"

#import "LSPrefixHeader.h"

@interface LSMessageController ()

@end

@implementation LSMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor colorFromHexString:@"EEE9E9"];
}

@end
