//
//  LSDoctorAdviceMessageCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSDoctorAdviceMessageCell.h"

@interface LSDoctorAdviceMessageCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation LSDoctorAdviceMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.bubbleView insertSubview:self.titleLab aboveSubview:self.bubbleView.backgroundImageView];
        [self.bubbleView insertSubview:self.line aboveSubview:self.bubbleView.backgroundImageView];
        [self.bubbleView insertSubview:self.contentLab aboveSubview:self.bubbleView.backgroundImageView];
        [self.bubbleView insertSubview:self.timeLab aboveSubview:self.bubbleView.backgroundImageView];
    }
    //添加子空间
    
    return self;
    
}
+ (NSString*) cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"LSDoctorAdviceMessageCell";
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    self.bubbleView.textLabel.text = @"";
//    self.textF1.text = self.conversation.ext[@"diagnosis"];
//    self.textF2.text = self.conversation.ext[@"advice"];
//    self.textF3.text = self.conversation.ext[@"pharmacy"];
//    self.textF4.text = self.conversation.ext[@"end_date"];
    self.contentLab.text = model.message.ext[@"diagnosis"];
    self.timeLab.text = model.message.ext[@"end_date"];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.bubbleView.backgroundImageView.mas_bottom);
    }];
    
}

//是否设置气泡
- (BOOL)isCustomBubbleView:(id)model
{
    return NO;
}

#pragma mark - getter & setter

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"医嘱";
    }
    return _titleLab;
}

- (UIView *)line
{
    if (!_line)
    {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR];
    }
    return _line;
}

- (UILabel *)contentLab
{
    if (!_contentLab)
    {
        _contentLab = [UILabel new];
        _contentLab.numberOfLines = 2;
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}

- (UILabel *)timeLab
{
    if (!_timeLab)
    {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:14];
    }
    return _timeLab;
}

@end
