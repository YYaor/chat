//
//  YGT30Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 17/1/12.
//
//

#import "YGT30Cell.h"

@interface YGT30Cell ()

@property (weak, nonatomic) IBOutlet UIImageView *noteImgView;//图标

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题


@end

@implementation YGT30Cell

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
    NSLog(@"%@",dataModel);
    
    if (dataModel.color == 1) {
        self.backgroundColor = UIColorFromRGB(0xF0FBFF);
    }
    
    self.titleLab.text = dataModel.text;
    
}

@end
