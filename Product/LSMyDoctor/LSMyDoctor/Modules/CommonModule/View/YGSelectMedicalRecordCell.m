//
//  YGSelectMedicalRecordCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/15.
//
//

#import "YGSelectMedicalRecordCell.h"

@implementation YGSelectMedicalRecordCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //添加子空间
 //   self.bubbleMaxWidth = 350.0f;
    
    return self;
    
}
+ (NSString*) cellIdentifierWithModel:(id<IMessageModel>)model
{
    return @"yGSelectMedicalRecordCell";
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0]];
    
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.text = @"我的病历";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15.0f];
    titleLab.textColor = Style_Color_Content_Black;
    [self.bubbleView insertSubview:titleLab aboveSubview:self.bubbleView.backgroundImageView];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleView).offset(15);
        make.top.equalTo(self.bubbleView).offset(15);
        make.height.equalTo(@30);
    }];
    
    
    //病历时间
    
    UILabel* timeLab = [[UILabel alloc] init];
    timeLab.text = model.message.ext[@"time"];
    timeLab.numberOfLines = 0;
    timeLab.font = [UIFont systemFontOfSize:15.0f];
    timeLab.textColor = Style_Color_Content_Black;
    [self.bubbleView insertSubview:timeLab aboveSubview:self.bubbleView.backgroundImageView];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubbleView).offset(-15);
        make.centerY.equalTo(titleLab.mas_centerY);
    }];
    
    UILabel* lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.bubbleView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_left);
        make.right.equalTo(timeLab.mas_right);
        make.top.equalTo(timeLab.mas_bottom).offset(8);
        make.height.equalTo(@1);
    }];
    
    WFHelperButton* detailBtn = [[WFHelperButton alloc] init];
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [detailBtn setTitleColor:Style_Color_Content_Blue forState:UIControlStateNormal];
    detailBtn.detail = model.message.ext[@"medicalRecordId"];//病历的id
    [detailBtn addTarget:self action:@selector(detaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bubbleView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bubbleView);
        make.top.equalTo(lineLab.mas_bottom);
    }];
    
    
    
}

#pragma mark -- 查看详情按钮点击
- (void)detaiBtnClick:(WFHelperButton*)sender
{
    NSLog(@"查看详情按钮点击");
    [self.delegate yGSelectMedicalRecordCellDetailBtnClick:sender];
}


//是否设置气泡
- (BOOL)isCustomBubbleView:(id)model
{
    return NO;
}

@end
