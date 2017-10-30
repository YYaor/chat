//
//  MDConsultDiscussCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDConsultDiscussCell.h"
@interface MDConsultDiscussCell()

@property (weak, nonatomic) IBOutlet UIImageView *groupImgView;//组像
@property (weak, nonatomic) IBOutlet UILabel *groupNameLab;//组名称
@property (weak, nonatomic) IBOutlet UILabel *valueLab;//聊天
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间


@end

@implementation MDConsultDiscussCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImgUrlStr:(NSString *)imgUrlStr
{
    _imgUrlStr = imgUrlStr;
    [self.groupImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,imgUrlStr]] placeholderImage:[UIImage imageNamed:@"people_blue"]];
}

- (void)setGroupNameStr:(NSString *)groupNameStr
{
    _groupNameStr = groupNameStr;
    self.groupNameLab.text = groupNameStr;
}
- (void)setValueStr:(NSString *)valueStr
{
    _valueStr = valueStr;
    if (valueStr.length > 0) {
        self.valueLab.hidden = NO;
        self.valueLab.text = valueStr;
    }else{
        self.valueLab.hidden = YES;
    }
}
- (void)setTimeStr:(NSString *)timeStr
{
    _timeStr = timeStr;
    if (timeStr.length > 0) {
        self.timeLab.hidden = NO;
        self.timeLab.text = timeStr;
    }else{
        self.timeLab.hidden = YES;
    }
}


@end
