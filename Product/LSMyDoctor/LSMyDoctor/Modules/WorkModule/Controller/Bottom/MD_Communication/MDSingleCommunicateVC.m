//
//  MDSingleCommunicateVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/18.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSingleCommunicateVC.h"
#import "MDPeerDetailVC.h"//医生详情界面

@interface MDSingleCommunicateVC ()

@end

@implementation MDSingleCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleNameStr;
    
    UIButton* singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [singleBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [singleBtn setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    [singleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    UIBarButtonItem *copyBarBtn = [[UIBarButtonItem alloc] initWithCustomView:singleBtn];
    self.navigationItem.rightBarButtonItem = copyBarBtn;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)rightBtnClick
{
    MDPeerDetailVC* detailVC = [[MDPeerDetailVC alloc] init];
    detailVC.doctorIdStr = self.singleIdStr;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
