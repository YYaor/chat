//
//  YougeRemindCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/29.
//
//

#import "YougeRemindCell.h"

@interface YougeRemindCell ()

@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *onionImageView;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation YougeRemindCell

- (void)awakeFromNib {
    // Initialization code
    //caption上的详情按钮
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
    
    //caption上的详情按钮点击回调
    _detailBlock(_dataModel.detail);
}

- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    self.dataModel = itemModel.data;
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    
    if (_itemModel.caption) {
        _legendView.hidden = NO;
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
        _legendView.hidden = YES;
        _topCon.constant = 0;
    }
    
    switch (dataModel.onion) {
        case 0:
            _onionImageView.image = [UIImage imageNamed:@"onionAver"];
            break;
        case 1:
            _onionImageView.image = [UIImage imageNamed:@"onionverygood"];
            break;
        case 2:
            _onionImageView.image = [UIImage imageNamed:@"oniongood"];
            break;
        case 3:
            _onionImageView.image = [UIImage imageNamed:@"onionaverage"];
            break;
        case 4:
            _onionImageView.image = [UIImage imageNamed:@"onionbad"];
            break;
        case 5:
            _onionImageView.image = [UIImage imageNamed:@"onionverybad"];
            break;
        default:
            _onionImageView.image = [UIImage imageNamed:@"onionaverage"];
            break;
    }
    NSArray *listArr = dataModel.list;
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    for (int i = 0; i < listArr.count; ++i) {
        
        [mutStr appendString:listArr[i]];
        if (i != listArr.count - 1 ) {
            [mutStr appendString:@"\n"];
        }
    }
    _textContentLabel.text = mutStr;
}

@end
