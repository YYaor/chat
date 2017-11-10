//
//  LSWorkArticleSubController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/10.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleSubController.h"

@interface LSWorkArticleSubController ()

@end

@implementation LSWorkArticleSubController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self requestData];
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"发布设置";
    
    
}

- (void)requestData
{
    LSWEAKSELF;
    
    //常用标签
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/getCommonLabels");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                
//                NSArray *array = responseObj[@"data"][@"list"];
//                
//                if (array.count == 0)
//                {
//                    [XHToast showCenterWithText:@"无数据"];
//                    return ;
//                }
//                
//                weakSelf.pickview=[[ZHPickView alloc] initPickviewWithArray:@[array] isHaveNavControler:NO];
//                weakSelf.pickview.delegate=self;
//                [weakSelf.pickview show];
                
            }else{
                NSLog(@"返回数据有误");
            }
        }else
        {
            [XHToast showCenterWithText:@"获取分类列表失败"];
        }
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

@end
