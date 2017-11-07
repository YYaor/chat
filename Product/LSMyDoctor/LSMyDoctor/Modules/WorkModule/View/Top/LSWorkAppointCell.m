//
//  LSWorkAppointCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAppointCell.h"

@implementation LSWorkAppointCell


//content	预约内容	string
//id	预约ID	number
//im_username	患者IM聊天ID	string	第三方聊天接口ID
//img_url	患者头像	string
//order_time	预约时间	string	yyyy-MM-dd HH:mm
//user_id	患者ID	number
//username

-(void)setDataDic:(NSMutableDictionary *)dataDic{
    self.nameLabel.text = dataDic[@"username"];
    self.sexAndAgeLabel.text = dataDic[@"content"];
    
    if (dataDic[@"img_url"]) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,dataDic[@"img_url"]]] placeholderImage:[UIImage imageNamed:@"headImg_public"]];

    }
    self.timeLabel.text = dataDic[@"order_time"];

}

@end
