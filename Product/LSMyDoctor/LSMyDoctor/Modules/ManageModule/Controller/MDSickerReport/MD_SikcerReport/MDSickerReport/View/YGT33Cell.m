//
//  YGT33Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 17/3/1.
//
//

#import "YGT33Cell.h"
@interface YGT33Cell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *markNameLab;//标签

@property (weak, nonatomic) IBOutlet UILabel *markValueLab;//标签内容


@end

@implementation YGT33Cell

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
    
    ReportCaptionModel *captionModel = itemModel.caption;
    
    _titleLab.text = captionModel.text;
    
    self.dataModel = itemModel.data;
    
}



- (void)setDataModel:(ReportItemDataModel *)dataModel
{
    _dataModel = dataModel;
    
    NSLog(@"%@",dataModel);
    
    _markNameLab.text = [NSString stringWithFormat:@"%@：",dataModel.ReplaceTitle];
    //标签
    NSString* valueStr = @"";
    if ([dataModel.list[0] isKindOfClass:[NSString class]]) {
        valueStr = dataModel.list[0];
    }
    for (int i = 1; i < dataModel.list.count ; i ++) {
        valueStr = [NSString stringWithFormat:@"%@ | %@",valueStr,dataModel.list[i]];
    }
    
    _markValueLab.text = valueStr;
    
    
    
    
}

@end
