//
//  YGComRequestCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/8.
//
//

#import "YGComRequestCell.h"

@implementation YGComRequestCell

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
    return @"yGComRequestCell";
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
 //   CGFloat contentHeight = [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:model.message.ext[@"content"]] > 30 ? [Function contentHeightWithSize:18.0 with:kScreenWidth * 0.5  string:model.message.ext[@"content"]] : 30 ;
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
    
    //同意拒绝按钮
    UIView* btnView = [[UIView alloc] init];
    [self.bubbleView insertSubview:btnView aboveSubview:self.bubbleView.backgroundImageView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bubbleView);
        make.bottom.equalTo(self.bubbleView).offset(-5);
        make.height.equalTo(@40);
    }];
    if ([[NSString stringWithFormat:@"%@",model.message.ext[@"isHaveStatus"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",model.message.ext[@"isHaveStatus"]] isEqualToString:@"2"]) {
        //已处理的
        for (UIView* v in btnView.subviews) {
            [v removeFromSuperview];
        }
        UILabel* statusLab = [[UILabel alloc] init];
        statusLab.textColor = [UIColor darkGrayColor];
        statusLab.text = [[NSString stringWithFormat:@"%@",model.message.ext[@"isHaveStatus"]] isEqualToString:@"1"] ? @"已同意" : @"已拒绝" ;
        [btnView addSubview:statusLab];
        [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btnView.mas_centerX);
            make.centerY.equalTo(btnView.mas_centerY);
        }];
    }else{
        
        //未处理的
        for (UIView* v in btnView.subviews) {
            [v removeFromSuperview];
        }
        UILabel* midelLab = [[UILabel alloc] init];
        [btnView addSubview:midelLab];
        [midelLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(btnView);
            make.width.height.equalTo(@1);
        }];
        WFHelperButton* agreeBtn = [[WFHelperButton alloc] init];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn setBackgroundColor:BaseColor];
        agreeBtn.index = 1;
        agreeBtn.detail = model.message.ext[@"bookRequestId"];
        agreeBtn.layer.masksToBounds = YES;
        agreeBtn.layer.cornerRadius = 15.0f;
        [agreeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btnView.mas_top).offset(5);
            make.bottom.equalTo(btnView.mas_bottom).offset(-5);
            make.left.equalTo(@10);
            make.right.equalTo(midelLab.mas_left).offset(-10);
        }];
        
        
        WFHelperButton* refuseBtn = [[WFHelperButton alloc] init];
        [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refuseBtn setBackgroundColor:[UIColor redColor]];
        refuseBtn.layer.masksToBounds = YES;
        refuseBtn.index = 0;
        refuseBtn.detail = model.message.ext[@"bookRequestId"];
        refuseBtn.layer.cornerRadius = 15.0f;
        [refuseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:refuseBtn];
        [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(agreeBtn);
            make.left.equalTo(midelLab.mas_right).offset(10);
            make.right.equalTo(btnView.mas_right).offset(-10);
        }];
        
    }
    
    
    //预约时间
    UILabel* timeLab = [[UILabel alloc] init];
    timeLab.text = model.message.ext[@"timeStr"];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.font = [UIFont systemFontOfSize:15.0f];
    [self.bubbleView insertSubview:timeLab aboveSubview:self.bubbleView.backgroundImageView];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleView).offset(5);
        make.centerX.equalTo(self.bubbleView);
        make.bottom.equalTo(btnView.mas_top);
        make.height.equalTo(@(25));
    }];
}


//是否设置气泡
- (BOOL)isCustomBubbleView:(id)model
{
    return NO;
}

#pragma mark -- 点击同意和拒绝
- (void)btnClick:(WFHelperButton*)sender
{
    NSLog(@"点击同意、拒绝按钮");
    self.sureBlock([NSString stringWithFormat:@"%ld",(long)sender.index] , sender.detail);
}





@end
