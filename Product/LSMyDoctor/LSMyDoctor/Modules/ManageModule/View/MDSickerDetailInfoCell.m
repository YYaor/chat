//
//  MDSickerDetailInfoCell.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerDetailInfoCell.h"
@interface MDSickerDetailInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexAndAgeLab;//性别和年龄
@property (weak, nonatomic) IBOutlet UIView *labelsView;//标签的View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;//View的高度


@end

@implementation MDSickerDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoModel:(MDSickerDetailModel *)infoModel
{
    _infoModel = infoModel;
    
    self.userNameLab.text = infoModel.username;
    NSString* sexStr = @"男";
    if ([infoModel.sex isEqualToString:@"1"]) {
        sexStr = @"男";
    }else if ([infoModel.sex isEqualToString:@"2"]){
        sexStr = @"女";
    }else{
        sexStr = infoModel.sex;
    }
    self.sexAndAgeLab.text = [NSString stringWithFormat:@"%@   %@",sexStr,[NSString getAgeFromBirthday:infoModel.birthday]];
    
    
    
    NSArray* labelsArr = [infoModel.userLabels allValues];
    NSLog(@"%@",labelsArr);
    
    
    
    
    
    
    
}


@end
