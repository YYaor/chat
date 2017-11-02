//
//  YGT28Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/15.
//
//

#import "YGT28Cell.h"

@interface YGT28Cell ()
@property (weak, nonatomic) IBOutlet UILabel *backLab;//背景Label

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//您要感谢自己，坚持记录下去
@property (weak, nonatomic) IBOutlet UILabel *detailOne;//关心和维护您的健康生活
@property (weak, nonatomic) IBOutlet UILabel *detailTwo;//佑格是您随行助手
@property (weak, nonatomic) IBOutlet UILabel *detailThree;//为您健康出谋划策

@property (weak, nonatomic) IBOutlet UILabel *resultLab;//您+佑格=健康生活
@property (weak, nonatomic) IBOutlet UIImageView *onionImgView;//右下角图片


@end

@implementation YGT28Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backLab.layer.cornerRadius = 6.0f;
    self.backLab.layer.borderWidth = 1.0f;
    self.backLab.layer.borderColor = BarColor.CGColor;
    
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
    
    self.titleLab.text = dataModel.T28_head;
    if (dataModel.T28_body.count == 3) {
        
        self.detailOne.text = dataModel.T28_body[0];
        self.detailTwo.text = dataModel.T28_body[1];
        self.detailThree.text = dataModel.T28_body[2];
    }
    self.resultLab.text = dataModel.T28_foot;
    
    switch (dataModel.T28_onion) {
        case 0:
            _onionImgView.image = [UIImage imageNamed:@"onionAver"];
            break;
        case 1:
            _onionImgView.image = [UIImage imageNamed:@"onionverygood"];
            break;
        case 2:
            _onionImgView.image = [UIImage imageNamed:@"oniongood"];
            break;
        case 3:
            _onionImgView.image = [UIImage imageNamed:@"onionaverage"];
            break;
        case 4:
            _onionImgView.image = [UIImage imageNamed:@"onionbad"];
            break;
        case 5:
            _onionImgView.image = [UIImage imageNamed:@"onionverybad"];
            break;
        default:
            _onionImgView.image = [UIImage imageNamed:@"onionaverage"];
            break;
    }
    
}

@end
