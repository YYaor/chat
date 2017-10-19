//
//  MDSickerRequestCell.m
//  MyDoctor
//
//  Created by 惠生 on 17/7/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDSickerRequestCell.h"
@interface MDSickerRequestCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;//姓名

@property (weak, nonatomic) IBOutlet UILabel *userValueLab;//请求内容

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;//同意

@property (weak, nonatomic) IBOutlet UILabel *sexAndAgeLab;//性别和年龄




@end

@implementation MDSickerRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius = 4.5f;
    
    self.userImgView.layer.masksToBounds = YES;
    self.userImgView.layer.cornerRadius = 20.0f;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -- 同意按钮点击
- (IBAction)agreeBtnClick:(UIButton *)sender
{
  //  [self.delegate mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:_sickerModel];
}


@end
