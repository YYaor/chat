//
//  YGSelfCureCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/5.
//
//

#import "YGSelfCureCell.h"

@interface YGSelfCureCell ()
@property (weak, nonatomic) IBOutlet UILabel *resultLab;//您的自愈评测结果为：
@property (weak, nonatomic) IBOutlet UILabel *resultStatusLab;//临界状态
@property (weak, nonatomic) IBOutlet UILabel *resultRemindLab;//您需要注意改善和提高您的自愈系统状况


@end



@implementation YGSelfCureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    self.resultLab.text = dataModel.label;
    self.resultStatusLab.text = dataModel.value;
    self.resultRemindLab.text = dataModel.notes;
    
    
}

@end
