//
//  MDGroupCommunicateVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDGroupCommunicateVC.h"
#import "MDGroupDiscussDetailVC.h"
#import "MDSickerGroupDetialVC.h"
@interface MDGroupCommunicateVC ()

@end

@implementation MDGroupCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.groupIdStr.length > 0) {
        UIButton* groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        groupBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
        [groupBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [groupBtn setImage:[UIImage imageNamed:@"people_white"] forState:UIControlStateNormal];
        [groupBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        UIBarButtonItem *copyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:groupBtn];
        self.navigationItem.rightBarButtonItem = copyBarBtn;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)rightBtnClick
{
    if (self.isPeer) {
        MDGroupDiscussDetailVC* detailVC = [[MDGroupDiscussDetailVC alloc] init];
        detailVC.groupIdStr = self.groupIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        MDSickerGroupDetialVC* detailVC = [[MDSickerGroupDetialVC alloc] init];
        detailVC.groupIdStr = self.groupIdStr;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


@end
