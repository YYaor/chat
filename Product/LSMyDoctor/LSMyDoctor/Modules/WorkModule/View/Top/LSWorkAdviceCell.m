//
//  LSWorkAdviceCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAdviceCell.h"

@interface LSWorkAdviceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;


@end

@implementation LSWorkAdviceCell

- (IBAction)agreeButtonClick
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:@100 forKey:@"id"];
    [param setValue:@1 forKey:@"result"];
    [param setValue:[Defaults objectForKey:@"cookie"] forKey:@"cookie"];
    [param setValue:AccessToken forKey:@"accessToken"];
    NSString *url = PATH(@"%@/dealwithRequest");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if (self.agreeClickBlock) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
            [dic setObject:@"已通过" forKey:@"remark"];
            self.agreeClickBlock(dic);
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}


@end
