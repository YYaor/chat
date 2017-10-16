//
//  LSWorkUsefulAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUsefulAddController.h"

@interface LSWorkUsefulAddController ()

@end

@implementation LSWorkUsefulAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"编辑常用语";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick
{
    
}

@end
