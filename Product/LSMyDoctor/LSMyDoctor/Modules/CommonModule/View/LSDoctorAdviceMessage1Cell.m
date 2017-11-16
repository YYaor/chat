//
//  LSDoctorAdviceMessageCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/16.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSDoctorAdviceMessage1Cell.h"

@interface LSDoctorAdviceMessage1Cell ()

@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *zhenduan;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation LSDoctorAdviceMessage1Cell

- (void)setData:(NSDictionary *)data
{
    self.username.text = data[@"username"];
    self.zhenduan.text = data[@"zhenduan"];
    self.time.text = data[@"time"];
    
    if ([data valueForKey:@"userimage"])
    {
        [self.header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, data[@"userimage"]]] placeholderImage:[UIImage imageNamed:@"user"]];
    }
    
    _data = data;
}

- (IBAction)press:(id)sender
{
    if (self.didSelected)
    {
        self.didSelected(self.data);
    }
    
}

@end
