//
//  LSManageController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageController.h"

#import "LSDataPickerView.h"


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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LSDataPickerView *p = [[NSBundle mainBundle] loadNibNamed:@"LSDataPickerView" owner:nil options:nil][0];
    [p setPickerWithArray:@[@"11", @"12", @"13"] title:@"11"];
    [p show];
}

@end
