//
//  MDComRequestCell.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/8.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDComRequestCell.h"

@implementation MDComRequestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //添加子空间
    
    return self;
    
}
+ (NSString*) cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"mDComRequestCell";
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.text = @"预约请求";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15.0f];
    titleLab.textColor = Style_Color_Content_Black;
    [self.bubbleView insertSubview:titleLab aboveSubview:self.bubbleView.backgroundImageView];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleView).offset(5);
        make.centerX.equalTo(self.bubbleView);
        make.top.equalTo(self.bubbleView);
        make.height.equalTo(@25);
    }];
    //预约内容
    
    CGFloat contentHeight = [model.message.ext[@"content"] heightWithFont:[UIFont systemFontOfSize:18.0f] constrainedToWidth:LSSCREENWIDTH * 0.5] > 30 ? [model.message.ext[@"content"] heightWithFont:[UIFont systemFontOfSize:18.0f] constrainedToWidth:LSSCREENWIDTH * 0.5] : 30 ;
    
    UILabel* valueLab = [[UILabel alloc] init];
    valueLab.text = model.message.ext[@"content"];
    valueLab.numberOfLines = 0;
    valueLab.font = [UIFont systemFontOfSize:15.0f];
    valueLab.textColor = Style_Color_Content_Black;
    [self.bubbleView insertSubview:valueLab aboveSubview:self.bubbleView.backgroundImageView];
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleView).offset(5);
        make.centerX.equalTo(self.bubbleView);
        make.height.equalTo(@(contentHeight));
        make.top.equalTo(titleLab.mas_bottom).offset(5);
    }];
    
    //预约时间
    UILabel* timeLab = [[UILabel alloc] init];
    timeLab.text = model.message.ext[@"timeStr"];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.font = [UIFont systemFontOfSize:15.0f];
    [self.bubbleView insertSubview:timeLab aboveSubview:self.bubbleView.backgroundImageView];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleView).offset(5);
        make.centerX.equalTo(self.bubbleView);
        make.bottom.equalTo(self.bubbleView);
        make.height.equalTo(@(25));
    }];
    
    
    
    
    
}


//是否设置气泡
- (BOOL)isCustomBubbleView:(id)model
{
    return NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
