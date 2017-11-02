//
//  MDSickerDetailBottomCell.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerDetailBottomCell.h"
@interface MDSickerDetailBottomCell()

@property (weak, nonatomic) IBOutlet UIView *backView;//放置按钮的View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;//高度

@end

@implementation MDSickerDetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat btnWidth = (LSSCREENWIDTH - 60) / 3;
    self.backViewHeight.constant = btnWidth + 10.0f;
    
    NSArray* titleArr = [NSArray arrayWithObjects:@"近7天报告",@"患者病历",@"我的医嘱", nil];
    NSArray* imgArr = [NSArray arrayWithObjects:@"outgoingrecords",@"patienthistory",@"mydoctoradvice", nil];
    
    for (UIView* v in self.backView.subviews) {
        [v removeFromSuperview];
    }
    
    
    for (int i = 0; i < 3; i++) {
        WFHelperButton* btn = [[WFHelperButton alloc] initWithFrame:CGRectMake(15 + (btnWidth + 15) * i, 5, btnWidth, btnWidth)];
        btn.index = i;
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:btn];
        //标题
        UILabel* btnTitleLab = [[UILabel alloc] init];
        btnTitleLab.text = titleArr[i];
        btnTitleLab.textColor = [UIColor darkGrayColor];
        btnTitleLab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:btnTitleLab];
        [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn.mas_bottom);
            make.left.equalTo(btn.mas_left);
            make.height.equalTo(btn.mas_height).multipliedBy(0.3);
        }];
        
        //图片
        UIImageView* btnImgView = [[UIImageView alloc] init];
        btnImgView.contentMode = UIViewContentModeScaleAspectFit;
        btnImgView.image = [UIImage imageNamed:imgArr[i]];
        [btn addSubview:btnImgView];
        [btnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.mas_equalTo(btnWidth * 0.14);
            make.width.mas_equalTo(btnWidth * 0.42);
            make.height.equalTo(btnImgView.mas_width);
            
        }];
        
        
    }
    
    // Initialization code
}

#pragma mark -- 按钮点击
- (void)bottomBtnClick:(WFHelperButton*)btn
{
    if (btn.index == 0) {
        //患者近7天报告按钮点击
        [self.delegate mDSickerDetailBottomCellSevenReportBtnClickWithBtn:btn];
    }else if (btn.index == 1){
        //患者病历按钮点击
        [self.delegate mDSickerDetailBottomCellSickerMedicalRecordBtnClickWithBtn:btn];
        
    }else{
        //我的医嘱按钮点击
        [self.delegate mDSickerDetailBottomCellMyAdviceBtnClickWithBtn:btn];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
