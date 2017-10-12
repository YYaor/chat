//
//  LSWorkArticleAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleAddController.h"

@interface LSWorkArticleAddController ()

@end

@implementation LSWorkArticleAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"创建文章";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick
{
    
}

@end
