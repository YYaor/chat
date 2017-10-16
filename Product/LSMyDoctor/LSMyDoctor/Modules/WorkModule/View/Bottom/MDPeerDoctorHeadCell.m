//
//  MDPeerDoctorHeadCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDPeerDoctorHeadCell.h"
@interface MDPeerDoctorHeadCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *projectLab;//科室和医生职位

@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLab;//医院名称

@end

@implementation MDPeerDoctorHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end