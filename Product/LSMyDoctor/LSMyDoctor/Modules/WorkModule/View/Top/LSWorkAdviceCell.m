//
//  LSWorkAdviceCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAdviceCell.h"

@interface LSWorkAdviceCell ()

@end

@implementation LSWorkAdviceCell


-(void)agreeButtonClick{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
//    [param setValue:@100 forKey:@"id"];
    [param setValue:@1 forKey:@"result"];
    NSString *url = PATH(@"%@/dr/dealwithRequest");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {

    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

@end
