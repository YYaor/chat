//
//  LSWorkActivityCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityCell.h"

@interface LSWorkActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *activity_time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *create_time;

@end

@implementation LSWorkActivityCell

- (void)setDataWithDictionary:(NSDictionary *)dic
{
    self.name.text = dic[@"name"];
    self.address.text = dic[@"address"];
    self.activity_time.text = dic[@"activity_time"];
    self.content.text = dic[@"content"];
    self.create_time.text = dic[@"create_time"];
}

@end
