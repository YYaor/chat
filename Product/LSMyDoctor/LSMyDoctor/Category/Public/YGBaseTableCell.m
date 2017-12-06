//
//  YGBaseTableCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/8.
//
//

#import "YGBaseTableCell.h"
@interface YGBaseTableCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueHeight;

@end

@implementation YGBaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailLab:(UILabel *)detailLab
{
    _detailLab = detailLab;
    
    CGFloat height = [detailLab.text heightWithFont:[UIFont systemFontOfSize:17.0f] constrainedToWidth:(self.bounds.size.width - 155)];
    
    self.valueHeight.constant = height > 40 ? height : 40 ;
    
}




@end
