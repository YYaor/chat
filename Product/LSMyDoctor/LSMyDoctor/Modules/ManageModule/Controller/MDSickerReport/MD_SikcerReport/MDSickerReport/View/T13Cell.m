//
//  T13Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 17/1/11.
//
//

#import "T13Cell.h"

@interface T13Cell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightVieqw;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;//高度约束
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation T13Cell

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
    
    //先清空要添加的视图
    for (UIView *view in self.leftView.subviews) {
        
        [view removeFromSuperview];
    }
    for (UIView *view in self.rightVieqw.subviews) {
        
        [view removeFromSuperview];
    }
    
    CGFloat width = kScreenWidth/2;
    CGFloat height = 30;
    NSInteger maxNum = dataModel.good.count >= dataModel.bad.count?dataModel.good.count:dataModel.bad.count;
    _heightCon.constant = maxNum * height;
    if (maxNum > 0) {
        
        for (int i = 0; i < maxNum; ++i) {
            //左
            UILabel *leftlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
            leftlabel.backgroundColor = UIColorHex(@"ccefdb");
            leftlabel.textAlignment = NSTextAlignmentCenter;
            leftlabel.textColor = [UIColor darkGrayColor];
            if (i < dataModel.good.count) {
                leftlabel.text = dataModel.good[i];
            }else{
                leftlabel.text = @"";
            }
            [self.leftView addSubview:leftlabel];
            
            //右
            UILabel *rightlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * height, width, height)];
            rightlabel.backgroundColor = UIColorHex(@"fbe8c8");
            rightlabel.textAlignment = NSTextAlignmentCenter;
            rightlabel.textColor = [UIColor darkGrayColor];
            if (i < dataModel.bad.count) {
                rightlabel.text = dataModel.bad[i];
            }else{
                rightlabel.text = @"";
            }
            [self.rightVieqw addSubview:rightlabel];
        }

    }
    
    
}

@end
