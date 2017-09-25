//
//  LSWorkController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkController.h"
#import "LSLoginController.h"

@interface LSWorkController ()

@end

@implementation LSWorkController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"工作台";
    self.view.backgroundColor = [UIColor colorFromHexString:@"FFB6C1"];
    
    UIButton *loignButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    loignButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:loignButton];
    [loignButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loginButtonClick{
    LSLoginController *loginVC = [[LSLoginController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

@end
