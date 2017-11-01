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
    
    NSArray *vcs = self.navigationController.viewControllers;
    
    LSMineUserSettingController *vc = vcs[vcs.count-2];
    
    //姓名
    NSMutableArray *arr = [NSMutableArray arrayWithArray:vc.model.myBaseInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arr[1]];
    [dic setValue:self.username.text forKey:@"value"];
    [arr replaceObjectAtIndex:1 withObject:dic];
    vc.model.myBaseInfo = arr;
    
    [vc updateMainInfoData];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
