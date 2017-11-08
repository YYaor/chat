//
//  LSWorkOutcallListCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallListCell.h"

@implementation LSWorkOutcallListCell


-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    if (self.dataDic[@"img_url"]) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,dataDic[@"img_url"]]] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    }
    
    self.nameLabel.text = dataDic[@"user_name"];
}
@end
