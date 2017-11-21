//
//  LSRecommendArticleMessageCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSRecommendArticleMessageCell.h"

@interface LSRecommendArticleMessageCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation LSRecommendArticleMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.bubbleView insertSubview:self.titleLab aboveSubview:self.bubbleView.backgroundImageView];
        [self.bubbleView insertSubview:self.line aboveSubview:self.bubbleView.backgroundImageView];
        [self.bubbleView insertSubview:self.contentLab aboveSubview:self.bubbleView.backgroundImageView];
    }
    //添加子空间
    
    return self;
    
}
+ (NSString*) cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"LSRecommendArticleMessageCell";
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    self.bubbleView.textLabel.text = @"";

    self.titleLab.text = model.message.ext[@"title"];
    self.contentLab.text = model.message.ext[@"content"];
    
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

@end
