//
//  MDChooseSickerCell.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDChooseSickerCell.h"
@interface MDChooseSickerCell()

@property (weak, nonatomic) IBOutlet UIButton *boxBtn;//选中与未选中box
@property (weak, nonatomic) IBOutlet UIImageView *sickerImgView;//患者头像
@property (weak, nonatomic) IBOutlet UILabel *sickerNameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexAndAgeLab;//性别和年龄
@property (weak, nonatomic) IBOutlet UILabel *importLab;//重点标记

@end

@implementation MDChooseSickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.importLab.layer.masksToBounds = YES;
    self.importLab.layer.cornerRadius = 14.0f;
    self.boxBtn.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.boxBtn.selected = isSelected;
    
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    [self.sickerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,imgUrl]] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    
}

- (void)setUserNameStr:(NSString *)userNameStr
{
    _userNameStr = userNameStr;
    self.sickerNameLab.text = userNameStr;
    
}
- (void)setSexAndAgeStr:(NSString *)sexAndAgeStr
{
    _sexAndAgeStr = sexAndAgeStr;
    self.sexAndAgeLab.text = sexAndAgeStr;
}
- (void)setIsImportant:(BOOL)isImportant
{
    _isImportant = isImportant;
    self.importLab.hidden = !isImportant;
}


@end
