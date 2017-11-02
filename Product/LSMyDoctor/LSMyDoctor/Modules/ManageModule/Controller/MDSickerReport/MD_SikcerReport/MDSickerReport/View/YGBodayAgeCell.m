//
//  YGBodayAgeCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/8.
//
//

#import "YGBodayAgeCell.h"

@interface YGBodayAgeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *onionImgView;//图片

@property (weak, nonatomic) IBOutlet UILabel *percentLab;//您击败了50%参加测试的同类人群

@property (weak, nonatomic) IBOutlet UILabel *remindLab;//您的身体年龄为55岁，和实际年龄基本一致，加油！


@end


@implementation YGBodayAgeCell

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
    
    switch (dataModel.onion) {
        case 0:
            self.onionImgView.image = [UIImage imageNamed:@"onionAver"];
            break;
        case 1:
            self.onionImgView.image = [UIImage imageNamed:@"onionverygood"];
            break;
        case 2:
            self.onionImgView.image = [UIImage imageNamed:@"oniongood"];
            break;
        case 3:
            self.onionImgView.image = [UIImage imageNamed:@"onionaverage"];
            break;
        case 4:
            self.onionImgView.image = [UIImage imageNamed:@"onionbad"];
            break;
        case 5:
            self.onionImgView.image = [UIImage imageNamed:@"onionverybad"];
            break;
        default:
            self.onionImgView.image = [UIImage imageNamed:@"onionaverage"];
            break;
    }
    
    
    self.percentLab.text = dataModel.message;
    self.remindLab.text = dataModel.ending;
    
    
}
@end
