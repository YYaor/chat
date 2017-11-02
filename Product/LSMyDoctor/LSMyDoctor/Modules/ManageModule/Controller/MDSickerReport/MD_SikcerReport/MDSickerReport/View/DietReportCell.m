//
//  DietReportCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/10/26.
//
//

#import "DietReportCell.h"
@interface DietReportCell()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *totalLabel;

@property (nonatomic, strong) UIView * standV;//标准区间图
@property (nonatomic, strong) UILabel * minLab;
@property (nonatomic, strong) UILabel * maxLab;

@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (nonatomic, strong) UIImageView * trangle;

@end
@implementation DietReportCell

- (void)awakeFromNib {
    self.standV = [[UIView alloc] init];
    self.standV.backgroundColor = RGBACOLOR(117, 168, 254, 1);
    [self.totalView addSubview:self.standV];
    
    self.trangle = [[UIImageView alloc] init];
    [self.contentView addSubview:self.trangle];
    
    self.min = 0;
    self.max = 1000;
    self.pre = 500;
    
    self.smin = 400;
    self.smax = 600;
//／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    CGFloat every = (self.max - self.min)/(kScreenWidth - 20);
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 16));
        make.top.equalTo(self.contentView).with.offset(37);
        make.centerX.equalTo(self.contentView.mas_left).with.offset(10 + self.pre / every);
    }];
    
    CGFloat standmin = self.smin /every;
    CGFloat standmax = self.smax / every;
    [self.standV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(standmax - standmin, 20));
        make.top.equalTo(self.totalView);
        make.left.equalTo(self.totalView).with.offset(standmin);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
