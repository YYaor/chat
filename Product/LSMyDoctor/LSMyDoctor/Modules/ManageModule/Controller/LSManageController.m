//
//  LSManageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageController.h"
#import "LSLoginController.h"
#import "LSDataPickerView.h"
#import "LSChoosePatientController.h"

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
    
    UIButton *loignButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    loignButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:loignButton];
    [loignButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginButtonClick
{
    LSChoosePatientController *choosePatientController = [[LSChoosePatientController  alloc]init];
    [self.navigationController pushViewController:choosePatientController animated:YES];
//    LSLoginController *loginVC = [[LSLoginController alloc]init];
//    loginVC.hidesBottomBarWhenPushed = YES;
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:^{
//        
//    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LSDataPickerView *p = [[NSBundle mainBundle] loadNibNamed:@"LSDataPickerView" owner:nil options:nil][0];
    [p setPickerWithArray:@[@"11", @"12", @"13"] title:@"11"];
    [p show];
}

@end