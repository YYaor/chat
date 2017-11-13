//
//  LSWorkTailDetailCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkTailDetailCell.h"

@interface LSWorkTailDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;


@end

@implementation LSWorkTailDetailCell

- (void)setDataWithDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        self.title.text = @"完成时间";
        self.subTitle.text = dic[@"end_date"];
    }
    else if (indexPath.row == 2)
    {
        self.title.text = @"医生诊断";
        self.subTitle.text = dic[@"diagnosis"];
    }
    else if (indexPath.row == 3)
    {
        self.title.text = @"医嘱";
        self.subTitle.text = dic[@"advice"];
    }
    else if (indexPath.row == 4)
    {
        self.title.text = @"用药";
        self.subTitle.text = dic[@"pharmacy"];
    }
}

@end
