//
//  YGStripCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/8.
//
//


/////////////////T04  柱状图////////////////////////


#import "YGStripCell.h"

@interface YGStripCell ()

@property (weak, nonatomic) IBOutlet UILabel *stripLab;


@end

@implementation YGStripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    for (UIView *v in _stripLab.subviews) {
        [v removeFromSuperview];
    }
    
    UILabel* titleLab = [[UILabel alloc] init];
    
    if (self.titleStr) {
        titleLab.text = self.titleStr;
    }else{
        titleLab.text = @" ";
    }
    if (self.left) {
        //左边
        titleLab.textAlignment = NSTextAlignmentLeft;
    }else{
        titleLab.textAlignment = NSTextAlignmentCenter;
    }
    titleLab.textColor = UIColorFromRGB(0x5593e8);
    [self.stripLab addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.height.equalTo(@25);
        make.left.equalTo(@8);
        make.right.equalTo(self.stripLab.mas_right).offset(-8);
    }];
    
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (int i = 0; i < dataModel.list.count; i++) {
        [titleArray addObject:dataModel.list[i][@"name"]];
        [valueArray addObject:[NSString stringWithFormat:@"%@",dataModel.list[i][@"value"]]];
    }
    
    
    
    //柱状图
    ZFBarChart *barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(-10, 40, kScreenWidth , kScreenWidth - 100)];
    barChart.xLineValueArray = [NSMutableArray arrayWithArray:valueArray];
    barChart.xLineTitleArray = [NSMutableArray arrayWithArray:titleArray];;
    barChart.yLineMaxValue = dataModel.max;
    barChart.xLineTitleFontSize = 12.0;
    barChart.title = dataModel.unit;//y轴显示值
    barChart.yLineSectionCount = 2;
    barChart.isShadow = NO;
    [_stripLab addSubview:barChart];
//    [barChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLab.mas_bottom);
//        make.left.equalTo(self.stripLab.mas_left).offset(40);
//        make.right.equalTo(self.stripLab.mas_right).offset(-40);
//        make.height.equalTo(barChart.mas_width);
//        
//    }];
    [barChart strokePath];
    
    NSLog(@"123");
    
}

@end
