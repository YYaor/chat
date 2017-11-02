//
//  YGT31Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 17/1/12.
//
//

#import "YGT31Cell.h"

@interface YGT31Cell ()

@property (weak, nonatomic) IBOutlet UILabel *legentLab;//控制布局Lab

@property (weak, nonatomic) IBOutlet UILabel *nameLab;//名称

@property (weak, nonatomic) IBOutlet UILabel *valueLab;//量

@property (weak, nonatomic) IBOutlet UILabel *unitNameLab;//单位

@property (weak, nonatomic) IBOutlet UILabel *unitValueLab;//单位值

@property (weak, nonatomic) IBOutlet UILabel *referenceNameLab;//参考值

@property (weak, nonatomic) IBOutlet UILabel *referenceValueLab;//参考值的值

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legentHeight;//cell高度布局

@end

@implementation YGT31Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ReportItemModel *)itemModel
{
    _itemModel = itemModel;
    NSLog(@"%@",itemModel);
    
    self.dataModel = itemModel.data;
    
    
}

- (void)setDataModel:(ReportItemDataModel *)dataModel
{
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    self.nameLab.text = dataModel.name;
    self.valueLab.text = dataModel.value;
    
    //单位值如果存在，则显示，若不存在，则隐藏
    if (dataModel.unit.length > 0) {
        
        self.unitValueLab.text = dataModel.unit;
    }else{
        self.unitValueLab.hidden = YES;
        self.unitNameLab.hidden = YES;
    }
    
    if (dataModel.referenceValue.length > 0) {
        
        self.referenceValueLab.text = dataModel.referenceValue;
    }else{
        self.referenceValueLab.hidden = YES;
        self.referenceNameLab.hidden = YES;
    }
    
    if (self.unitNameLab.hidden && self.referenceNameLab.hidden) {
        self.legentHeight.constant = 50.0f;
    }
    
}

@end
