//
//  T17Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import "T17Cell.h"

@interface T17Cell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet UIView *captionView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@end

@implementation T17Cell

- (void)awakeFromNib {
    // Initialization code
    
    [_detailButton setTitle:@"详情" forState:UIControlStateNormal];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.borderWidth = 1;
    _detailButton.layer.cornerRadius = 5;
    [_detailButton setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    _detailButton.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)detailButtonCLicked:(id)sender {
    
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
            _detailButton.hidden = NO;
        }else{
            _detailButton.hidden = YES;
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
        _topCon.constant = 0;
    }
    
    for (UIView *view in self.reportView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger listCount = dataModel.list.count;//行数
    NSInteger namesCount = dataModel.names.count;//列数
    CGFloat height = 40;
    
    if (namesCount > 0) {
        
        CGFloat width = kScreenWidth/namesCount;
        
        for (int i = 0; i <= listCount; ++i) {
            //行高
            
            if (i != 0) {
                if ([dataModel.list[i - 1] isKindOfClass:[NSArray class]]) {
                    NSArray* listArr = dataModel.list[i - 1];
                    if (listArr.count > 3) {
                        NSString* listDataStr = [dataModel.list[i - 1 ][3] stringByReplacingOccurrencesOfString:@"\n" withString:@"a"];
                        NSInteger num = [self CharInNSString:listDataStr Char:'a'];
                        height = 15 * (num + 2);
                    }
                }
                
            }
            
            
            _heightCon.constant = (listCount + 1)*height;
            
            
            for (int j = 0; j < namesCount; ++j) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j * width, height * i, width, height)];
                label.textAlignment = NSTextAlignmentCenter;
                if (kScreenWidth > 375) {
                    
                    label.font = [UIFont systemFontOfSize:17];
                    label.numberOfLines = 0;
                }else{
                    
                    label.font = [UIFont systemFontOfSize:14];
                    label.numberOfLines = 0;
                }
                [self.reportView addSubview:label];
                if (i == 0) {
                    label.text = dataModel.names[j];
                    label.textColor = UIColorHex(@"212121");
                    label.backgroundColor = UIColorHex(@"DDFBE9");
                }else{
                    
                    label.textColor = UIColorHex(@"212121");
                    label.text = [NSString stringWithFormat:@"%@",dataModel.list[i - 1][j]];
                    
                    
                    
                }
            }
        }
    }else{
        _heightCon.constant = listCount*height;
        
        for (int i = 0; i < listCount; ++i) {
            
            NSInteger row = [(NSArray*)dataModel.list[i] count];
            CGFloat width = kScreenWidth/row;
            
            for (int j = 0; j < row; ++j) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j * width, height * i, width, height)];
                label.textAlignment = NSTextAlignmentCenter;
                if (kScreenWidth > 375) {
                    
                    label.font = [UIFont systemFontOfSize:17];
                }else{
                    
                    label.font = [UIFont systemFontOfSize:14];
                }
                [self.reportView addSubview:label];
                //                if (i == 0) {
                //                    label.text = dataModel.names[j];
                //                    label.textColor = UIColorHex(@"212121");
                //                    label.backgroundColor = UIColorHex(@"DDFBE9");
                //                }else{
                
                label.textColor = UIColorHex(@"212121");
                label.text = [NSString stringWithFormat:@"%@",dataModel.list[i][j]];
                //                }
            }
        }
    }
    
    
    
}


- (NSInteger)CharInNSString:(NSString *)string Char:(char)c

{
    
    NSInteger x = 0;
    
    for (int i = 0; i < [string length]; i++) {
        
        if ((char)[string characterAtIndex:i] == c ) {
            
            NSLog(@"%c",(char)[string characterAtIndex:i]);
            
            x++;
            
        }
        
    }
    
    return x;
    
}

@end
