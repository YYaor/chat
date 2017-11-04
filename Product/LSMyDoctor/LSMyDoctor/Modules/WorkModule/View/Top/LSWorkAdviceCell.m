//
//  LSWorkAdviceCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAdviceCell.h"
#import "FMDBTool.h"
@interface LSWorkAdviceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *agreebutton;


@end

@implementation LSWorkAdviceCell

-(void)setDataDic:(NSMutableDictionary *)dataDic{
    _dataDic = dataDic;
    if (dataDic[@"img_url"]) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,dataDic[@"img_url"]]] placeholderImage:nil];
    }

    self.nameLab.text = dataDic[@"username"];
    self.infoLab.text = dataDic[@"remark"];
    
    if ([dataDic[@"result"] isEqualToString:@"已通过"]) {
        [self.agreebutton setTitle:@"已通过" forState:UIControlStateNormal];
        self.agreebutton.enabled = NO;
        self.agreebutton.layer.borderColor = [UIColor clearColor].CGColor;
        [self.agreebutton setTitleColor:[UIColor colorFromHexString:LSDARKGRAYCOLOR] forState:UIControlStateNormal];
    }else{
        [self.agreebutton setTitle:@"同意" forState:UIControlStateNormal];
        self.agreebutton.enabled = YES;
        self.agreebutton.layer.borderColor = [UIColor colorFromHexString:LSGREENCOLOR].CGColor;
        [self.agreebutton setTitleColor:[UIColor colorFromHexString:LSGREENCOLOR] forState:UIControlStateNormal];
    }
}

- (IBAction)agreeButtonClick
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.dataDic[@"id"] forKey:@"id"];
    [param setValue:@1 forKey:@"result"];

    NSString *url = PATH(@"%@/dealwithRequest");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj[@"data"][@"status"] integerValue] == 0) {
            if (self.agreeClickBlock) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setObject:@"已通过" forKey:@"remark"];
                self.agreeClickBlock(dic);
            }
        }
        if (self.agreeClickBlock) {
            self.agreeClickBlock(nil);
        }
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}


@end
