//
//  LSMineUserNameController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserNameController.h"

#import "LSMineUserSettingController.h"

@interface LSMineUserNameController ()

@property (weak, nonatomic) IBOutlet UITextField *username;

@end

@implementation LSMineUserNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"编辑姓名";
    
    self.username.text = self.model.myName;
    self.username.placeholder = @"请输入姓名";
}

- (IBAction)saveBtnClick
{
    if ([self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0)
    {
        [XHToast showCenterWithText:@"请输入姓名"];
        return;
    }
    
    NSArray *arr = self.navigationController.viewControllers;
    
    LSMineUserSettingController *vc = arr[arr.count-2];
    
    [vc updateMainInfoData];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
