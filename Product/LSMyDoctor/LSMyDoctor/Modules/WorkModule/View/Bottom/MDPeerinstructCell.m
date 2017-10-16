//
//  MDPeerinstructCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/22.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDPeerinstructCell.h"

@interface MDPeerinstructCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题

@property (weak, nonatomic) IBOutlet UILabel *valueLab;//值

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabHeight;//高度

@end

@implementation MDPeerinstructCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
- (void)setValueStr:(NSString *)valueStr
{
    _valueStr = valueStr;
    self.valueLab.text = valueStr;
    
}


@end
