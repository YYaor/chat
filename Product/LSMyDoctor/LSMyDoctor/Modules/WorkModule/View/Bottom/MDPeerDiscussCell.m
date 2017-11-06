//
//  MDPeerDiscussCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/22.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDPeerDiscussCell.h"

@interface MDPeerDiscussCell()

@property (weak, nonatomic) IBOutlet UIView *starView;//星级View
@property (weak, nonatomic) IBOutlet UILabel *sickNameLab;//疾病名称
@property (weak, nonatomic) IBOutlet UILabel *discussValueLab;//评价内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussValueLabHeight;//评价内容的高度
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;//患者名称
@property (weak, nonatomic) IBOutlet UILabel *discussTimeLab;//评价时间

@end

@implementation MDPeerDiscussCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setModel:(MDDoctorDetailEvaluateModel *)model
{
    _model = model;
    //星星
    NSInteger selctNum = [model.score integerValue];//选中的几个星星
    for (UIView* v in self.starView.subviews) {
        [v removeFromSuperview];
    }
    CGFloat jianju = 5.0f;
    CGFloat starWidth = 20.0f;
    
    for ( int i = 0; i < 5; i ++) {
        
        CGFloat x = (starWidth + jianju) * i;
        
        WFHelperButton* starBtn = [[WFHelperButton alloc] initWithFrame:CGRectMake(x, 8, starWidth, starWidth)];
        starBtn.index = i;
        starBtn.selected = NO;
        if (i <= selctNum - 1) {
            starBtn.selected = YES;
        }else{
            starBtn.selected = NO;
        }
        [starBtn setBackgroundImage:[UIImage imageNamed:@"star_grey"] forState:UIControlStateNormal];
        [starBtn setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateSelected];
        
        [self.starView addSubview:starBtn];
    }
    
    //内容
    self.discussValueLab.text = model.symptom;
    
    self.discussValueLabHeight.constant = [model.symptom heightWithFont:[UIFont systemFontOfSize:17.0f] constrainedToWidth:LSSCREENWIDTH - 16];
    //时间
    self.discussTimeLab.text = model.createTime;
    //姓名
    self.userNameLab.text = model.name;
    
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
