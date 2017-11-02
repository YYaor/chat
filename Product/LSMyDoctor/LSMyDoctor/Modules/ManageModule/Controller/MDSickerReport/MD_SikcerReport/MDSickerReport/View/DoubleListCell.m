//
//  DoubleListCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/29.
//
//

#import "DoubleListCell.h"

@interface DoubleListCell ()

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;//距离顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeiCon;//内容高度约束
@end

@implementation DoubleListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    
    if (itemModel.caption) {
        //有报告标题
        _topCon.constant = 40;
        if (itemModel.caption.left) {
            //居左
            _captionLabel.backgroundColor = [UIColor whiteColor];
            _captionLabel.textColor = UIColorFromRGB(0x5593E8);
            _captionLabel.font = [UIFont systemFontOfSize:24];
            _captionLabel.textAlignment = NSTextAlignmentLeft;
            _captionLabel.text = [NSString stringWithFormat:@"    %@",itemModel.caption.text];
        }else{
            //居中
            _captionLabel.backgroundColor = RGBCOLOR(207, 245, 222);
            _captionLabel.textColor = Style_Color_Content_Black;
            _captionLabel.textAlignment = NSTextAlignmentCenter;
            _captionLabel.text = itemModel.caption.text;
        }
    }else{
        //无报告标题
        _topCon.constant = 0;
    }
    //计算文字高度，取高的一个
    for (UIView *v in _reportView.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
    _contentHeiCon.constant = 0;
    NSArray *list = itemModel.data.list;
    for (int i = 0; i < list.count; ++i) {
        
        NSDictionary *dict = list[i];
        CGFloat width = kScreenWidth/2 - 14;
        
        NSString *name = dict[@"name"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
        //    [dic setObject:paragraphStyle1 forKey:NSParagraphStyleAttributeName];
        CGSize size1 = [name boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        NSArray *values = dict[@"values"];
        NSMutableString *mutStr = [[NSMutableString alloc] init];
        for (int i = 0; i < values.count;++i) {
            NSString *value = values[i];
            if (i == values.count - 1) {
                [mutStr appendString:value];
            }else{
                [mutStr appendFormat:@"%@、",value];
            }
        }
        CGSize size2 = [mutStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        CGFloat height = size1.height > size2.height?size1.height + 25 : size2.height + 25;
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:18];
        if (i == 0) {
            leftLabel.frame = CGRectMake(14, _contentHeiCon.constant + 7.5, width, height);
        }else{
            leftLabel.frame = CGRectMake(14, _contentHeiCon.constant + 7.5, width, height);
        }
        leftLabel.text = name;
        leftLabel.textColor = [UIColor darkGrayColor];
        leftLabel.numberOfLines = 0;
        [_reportView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:18];
        if (i == 0) {
            rightLabel.frame = CGRectMake(kScreenWidth/2, _contentHeiCon.constant + 7.5, width, height);
        }else{
            rightLabel.frame = CGRectMake(kScreenWidth/2, _contentHeiCon.constant + 7.5, width, height);
        }
        rightLabel.text = mutStr;
        rightLabel.textColor = Style_Color_Content_Black;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.numberOfLines = 0;
        [_reportView addSubview:rightLabel];
        
        _contentHeiCon.constant += height + 10;
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorFromRGB(0xefefef);
        [_reportView addSubview:label];
        __weak typeof(self) weakSelf = self;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf);
            make.top.equalTo(@(_contentHeiCon.constant + 2.5));
        }];
    }
    
    
}

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    NSArray *values = dict[@"values"];
    for (int i = 0; i < values.count; ++i) {
        NSString *str = values[i];
        [mutStr appendString:str];
        if (i != values.count - 1) {
            [mutStr appendString:@"、"];
        }
    }
    
    _leftLabel.text = dict[@"name"];
    _rightLabel.text = mutStr;
}

@end
