//
//  LSWorkArticleAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleAddController.h"

@interface LSWorkArticleAddController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextF;

@property (weak, nonatomic) IBOutlet UITextField *keyTextF;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *contentTextV;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

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
    
    self.contentTextV.placeholder = @"请输入内容";
}

- (void)rightItemClick
{
    
}

- (IBAction)scanBtnClick:(UIButton *)sender
{
    
}

- (IBAction)imgBtnClick:(UIButton *)btn
{
    
}

@end
