//
//  YGIllnessomplaintCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/15.
//
//

#import "YGIllnessomplaintCell.h"

@implementation YGIllnessomplaintCell

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
    return @"yGIllnessomplaintCell";
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.text = @"病情主诉";
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
    //主诉内容内容
//    CGFloat contentHeight = [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:model.message.ext[@"content"]] > 30 ? [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:model.message.ext[@"content"]] : 30 ;
    CGFloat contentHeight = 30;
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
    
    
    
    
}


//是否设置气泡
- (BOOL)isCustomBubbleView:(id)model
{
    return NO;
}

@end
