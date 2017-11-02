//
//  T09Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 17/1/12.
//
//

#import "T09Cell.h"

@interface T09Cell ()

@property (weak, nonatomic) IBOutlet UIView *reportListView;//报告列表视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;//高度约束
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScollView;

@end
@implementation T09Cell

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
        _captionLabel.hidden = NO;
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
        _topCon.constant = 0;
    }
    
    //清空报告列表子视图
    for (UIView *view in _contentScollView.subviews) {
            [view removeFromSuperview];
    }
    NSInteger num = dataModel.names.count;
    CGFloat width = 120;
    CGFloat height = 30;
    CGFloat btnW = 50;
    _contentScollView.contentSize = CGSizeMake(width * num, height * (dataModel.list.count + 1));
    _heightCon.constant = height * (dataModel.list.count + 1);
    //行
    for (int i = 0; i <= dataModel.list.count; ++i) {
        //列
        for (int j = 0;j < num; ++j) {
            
            CGRect rect = CGRectMake(j*width, i * height, width, height);
            if (i == 0) {
                //第一列
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorHex(@"212121");
                label.font = [UIFont systemFontOfSize:16.0f];
                label.textAlignment = NSTextAlignmentCenter;
                NSString *str = dataModel.names[j];
                if ([str isEqualToString:@"null"]) {
                    label.text = @"";
                }else{
                    label.text = str;
                }
                [_contentScollView addSubview:label];
            }else{
                if (j == num - 1) {
                    NSString *detail = dataModel.list[i - 1][j];
                    //最后一个为按钮
                    WFHelperButton *btn = [[WFHelperButton alloc] initWithFrame:CGRectMake(j*width + (width - btnW)/2, i * height + 4, btnW, height - 8)];
                    btn.detail = detail;
                    [btn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitle:dataModel.buttonText forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:16];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    btn.layer.borderWidth = 1;
                    if (detail.length > 0) {
                        btn.userInteractionEnabled = YES;
                        btn.layer.borderColor = RGBCOLOR(55, 110, 224).CGColor;
                        [btn setTitleColor:UIColorFromRGB(0x5795e6) forState:UIControlStateNormal];
                    }else{
                        btn.userInteractionEnabled = NO;
                        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
                        [btn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
                        
                    }
                    
                    [_contentScollView addSubview:btn];
                }else{
                    UILabel *label = [[UILabel alloc] initWithFrame:rect];
                    label.font = [UIFont systemFontOfSize:16.0f];
                    label.textColor = UIColorHex(@"212121");
                    label.textAlignment = NSTextAlignmentCenter;
                    NSString *str = dataModel.list[i - 1][j];
                    if ([str isEqualToString:@"null"]) {
                        label.text = @"";
                    }else{
                        label.text = str;
                    }
                    [_contentScollView addSubview:label];
                }
            }
        }
    }
}

- (void)otherBtnClicked:(WFHelperButton *)other{
    
    if (other.detail.length > 0) {
        [AlertHelper InitMyAlertMessage:other.detail And:_vc];
    }
}

@end
