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
    
    for (UIView* v in self.labelsView.subviews) {
        [v removeFromSuperview];
    }
    
    NSInteger numRow = 1;//取行数，向上取整
    if (labelsArr.count + 1 >= 4) {
        numRow = (NSInteger)ceilf(((float)labelsArr.count + 1)/4);
        
        numRow = numRow > 2 ? 2 : numRow;
    }
    
    CGFloat labelWidth = (LSSCREENWIDTH - 25)/4;
    CGFloat labelHeight = labelWidth/3;
    
    self.viewHeight.constant = numRow * (labelHeight + 8);
    
    if (labelsArr.count + 1 > 0) {
        
        for (int i = 0; i < numRow; i++) {
            for(int j = 0 ;j < 4; j ++){
                
                UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((labelWidth + 5)*j , (labelHeight + 8)*i, labelWidth, labelHeight)];
                
                if (4 * i + j  > labelsArr.count) {
                    label.text = @"测试";
                }else if(4 * i + j == 0){
                    label.text = @"标签：";
                    label.textColor = BaseColor;
                    label.textAlignment = NSTextAlignmentRight;
                    label.font = [UIFont systemFontOfSize:20];
                }else{
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor whiteColor];
                    label.layer.masksToBounds = YES;
                    label.layer.cornerRadius = labelHeight/2;
                    label.backgroundColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfSize:15];
                    label.text = labelsArr[4*i+j - 1];
                }
                
                [self.labelsView addSubview:label];
                if (4 * i + j  > labelsArr.count) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                }
                
            }
            
        }
        
    }

    
    
    
    
    
    
    
    
}


@end
