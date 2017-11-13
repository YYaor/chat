//
//  LSWorkTailDetailUserCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkTailDetailUserCell.h"

@interface LSWorkTailDetailUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img_url;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

@implementation LSWorkTailDetailUserCell

- (void)setDataWithDictionary:(NSDictionary *)dic
{
    [self.img_url sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, dic[@"img_url"]]] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    
    self.username.text = dic[@"username"];
    
    self.info.text = [NSString stringWithFormat:@"%@  %@", dic[@"sex"], dic[@"birthday"]];
    
    self.status.text = dic[@"status"];
    
    if ([dic[@"status"] isEqualToString:@"进行中"])
    {
        self.status.textColor = [UIColor colorFromHexString:LSGREENCOLOR];
    }
    else if ([dic[@"status"] isEqualToString:@"已完成"])
    {
        self.status.textColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
    }
    else if ([dic[@"status"] isEqualToString:@"未完成"])
    {
        self.status.textColor = [UIColor colorFromHexString:LSTIPCOLOR];
    }
}

@end
