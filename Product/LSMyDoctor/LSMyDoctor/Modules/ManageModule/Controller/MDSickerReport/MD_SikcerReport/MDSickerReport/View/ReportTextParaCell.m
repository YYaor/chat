//
//  ReportTextParaCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/28.
//
//

#import "ReportTextParaCell.h"
#import "NSString+Size.h"

@interface ReportTextParaCell ()

@property (weak, nonatomic) IBOutlet UILabel *captionLabel;//标题
@property (weak, nonatomic) IBOutlet UIView *reportContentView;//内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeiCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;


@end

@implementation ReportTextParaCell

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
            _captionLabel.backgroundColor = UIColorHex(@"f1faff");
            _captionLabel.textColor = UIColorHex(@"008fed");
            _captionLabel.textAlignment = NSTextAlignmentLeft;
            _captionLabel.text = [NSString stringWithFormat:@"    %@",itemModel.caption.text];
        }else{
            //居中
            _captionLabel.backgroundColor = RGBCOLOR(207, 245, 222);
            _captionLabel.textColor = UIColorHex(@"212121");
            _captionLabel.textAlignment = NSTextAlignmentCenter;
            _captionLabel.text = itemModel.caption.text;
        }
    }else{
        //无报告标题
        _topCon.constant = 10;
    }
    //展示报告内容
    for (UIView *v in _reportContentView.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
    _contentHeiCon.constant = 0;
    
    NSArray *list = itemModel.data.list;
    CGFloat x = 14;
    CGFloat width = kScreenWidth - 28;
//    NSArray *list = @[@"这是一段很长的字符串，我们将根据要求的字体大小，来计算实际需要的宽度和高度",@"我们将根据要求的字体大小，来计算实际需要的宽度和高",@"，我们常常需要计算，特定文本的宽度和高度。然后，根据长度和宽度值，动态的设置容器",@"然后，根据长度和宽度值，动态的设置容器"];
    
    
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    for (int i = 0; i < list.count; ++i) {
        
        NSString *str = list[i];
        NSString * cLabelString = [NSString stringWithFormat:@"      %@\n",str];
        [mutStr appendString:cLabelString];
        
    }
    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:mutStr];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:8];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [mutStr length])];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
//    [dic setObject:paragraphStyle1 forKey:NSParagraphStyleAttributeName];
    CGSize size = [mutStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, _contentHeiCon.constant + 8, width, size.height)];
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.text = mutStr;
    label.textColor = [UIColor darkGrayColor];
    [_reportContentView addSubview:label];
    _contentHeiCon.constant = size.height;
}

- (void)setTextStr:(NSString *)textStr{
    
    _textStr = textStr;
    
    NSString * cLabelString = [NSString stringWithFormat:@"        %@",textStr];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:cLabelString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [cLabelString length])];
    //[_textContentLabel setAttributedText:attributedString1];
//    _textContentLabel.text = [NSString stringWithFormat:@"        %@",textStr];
//    [_textContentLabel sizeToFit];
    
}

@end
