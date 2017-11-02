//
//  YGT14Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/15.
//
//

#import "YGT14Cell.h"

@interface YGT14Cell ()

@property (weak, nonatomic) IBOutlet UILabel *cellLab;//背景Label

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//您今日能量总消耗为：
@property (weak, nonatomic) IBOutlet UILabel *useNumLab;//消耗量（1400）
@property (weak, nonatomic) IBOutlet UILabel *pcsLab;//千卡





@end

@implementation YGT14Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataModel:(ReportItemDataModel *)dataModel
{
    _dataModel = dataModel;
    NSLog(@"123");
    
    self.titleLab.text = dataModel.name;
    self.useNumLab.text = dataModel.value;
    self.pcsLab.text = dataModel.unit;
    
    NSString* colorStr = [NSString stringWithFormat:@"%ld",(long)dataModel.color];
    if ([colorStr isEqualToString:@"1"])
    {
        //绿色
        self.useNumLab.textColor = BarColor;
    }else if ([colorStr isEqualToString:@"2"]){
        //橙色
        self.useNumLab.textColor = UIColorFromRGB(0xffb434);
        
    }
    
    
    
    
    
    
}
@end
