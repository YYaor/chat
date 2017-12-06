//
//  MDHealthEducationCell.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/22.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDHealthEducationCell.h"

@interface MDHealthEducationCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *signUpNumLab;//报名人数

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;//背景View的高度
@property (weak, nonatomic) IBOutlet UILabel *signUpLineLab;//已报名人数的条数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpLineLabHeight;//已报名人数的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpLineLabWidth;//已报名人数的宽度


@end


@implementation MDHealthEducationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.signUpLineLab.layer.masksToBounds = YES;
    self.signUpLineLab.layer.cornerRadius = 5.0f;
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
- (void)setSignUpNumStr:(NSString *)signUpNumStr
{
    _signUpNumStr = signUpNumStr;
    self.signUpNumLab.text = signUpNumStr;
}
- (void)setTotalNumStr:(NSString *)totalNumStr
{
    _totalNumStr = totalNumStr;
    
    NSInteger totalWidth = kScreenWidth - 30;
    
    NSInteger width = [_signUpNumStr integerValue] * ([totalNumStr integerValue] / totalWidth);
    self.signUpLineLabWidth.constant = width > 2 ? width : 2 ;
}

@end
