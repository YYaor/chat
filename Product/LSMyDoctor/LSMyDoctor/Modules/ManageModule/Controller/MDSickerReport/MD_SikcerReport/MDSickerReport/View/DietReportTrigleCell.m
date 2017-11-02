//
//  DietReportTrigleCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/10/26.
//
//

#import "DietReportTrigleCell.h"
#import "ThreeDimV.h"
@implementation DietReportTrigleCell{
    ThreeDimV * th;//三餐均衡三维坐标图
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        th = [[ThreeDimV alloc] init];
        [self.contentView addSubview:th];
    }
    return self;
}


- (void)layoutSubviews{
    [th mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth));
    }];
   // th.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
