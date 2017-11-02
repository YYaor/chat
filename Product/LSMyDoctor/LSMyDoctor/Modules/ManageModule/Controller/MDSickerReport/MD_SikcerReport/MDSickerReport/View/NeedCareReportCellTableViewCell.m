//
//  NeedCareReportCellTableViewCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/11/7.
//
//

#import "NeedCareReportCellTableViewCell.h"

@interface NeedCareReportCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *careContentLabel;
@property (weak, nonatomic) IBOutlet UIView *captionView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;


@end

@implementation NeedCareReportCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [_detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.cornerRadius = 5;
    [_detailBtn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    _detailBtn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)detailBtnClicked:(id)sender {
    
    _detailBlock(_dataModel.detail);
}

- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    self.dataModel = itemModel.data;
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    
    if (_itemModel.caption) {
        _captionView.hidden = NO;
        _topCon.constant = 40;
        if (_dataModel.detail) {
            _detailBtn.hidden = NO;
        }else{
            _detailBtn.hidden = YES;
        }
        if (_itemModel.caption.left) {
            //居左
            _captionLabel.backgroundColor = [UIColor whiteColor];
            _captionLabel.textColor = UIColorHex(@"008fed");
            _captionLabel.textAlignment = NSTextAlignmentLeft;
            _captionLabel.text = [NSString stringWithFormat:@"    %@",_itemModel.caption.text];
        }else{
            //居中
            _captionLabel.backgroundColor = RGBCOLOR(207, 245, 222);
            _captionLabel.textColor = UIColorHex(@"212121");
            _captionLabel.textAlignment = NSTextAlignmentCenter;
            _captionLabel.text = _itemModel.caption.text;
        }
    }else{
        _captionView.hidden = YES;
        _topCon.constant = 10;
    }
    
    NSArray *listArr = dataModel.list;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < listArr.count; ++i) {
        
        
        [mutStr  appendAttributedString:[WFLayoutHelper mixImageFront:[UIImage imageNamed:@"tips_green"] textBack:listArr[i]]];
        if (i != listArr.count - 1 ) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"\n"];
            [mutStr appendAttributedString:attrStr];
        }
    }
    _careContentLabel.attributedText = mutStr;
    
}

@end
