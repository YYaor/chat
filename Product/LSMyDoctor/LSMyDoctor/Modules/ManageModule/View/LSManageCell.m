//
//  LSManageCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageCell.h"

@interface LSManageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img_url;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userinfo;

@property (weak, nonatomic) IBOutlet UILabel *is_focus;

@end

@implementation LSManageCell

- (void)setDataWithEntity:(LSManageModel *)entity
{
    [self.img_url sd_setImageWithURL:[NSURL URLWithString:entity.img_url] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    self.username.text = entity.username;
    self.userinfo.text = [NSString stringWithFormat:@"%@  %@", entity.sex, entity.age];
    
    if ([entity.is_focus isEqualToString:@"0"])
    {
        self.is_focus.hidden = YES;
    }
    else
    {
        self.is_focus.hidden = NO;
    }
}

@end
