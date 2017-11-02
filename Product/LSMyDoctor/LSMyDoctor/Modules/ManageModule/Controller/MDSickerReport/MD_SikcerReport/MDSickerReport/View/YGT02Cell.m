//
//  YGT02Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/9.
//
//

#import "YGT02Cell.h"
#import "GYRRadarChart.h"

@interface YGT02Cell ()<RadarMapLegendTappedHandler>

@property (weak, nonatomic) IBOutlet UILabel *redarLab;//雷达图显示区域

@property (strong, nonatomic) GYRRadarChart *radarChartView;

@end

@implementation YGT02Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 初始值
    self.radarChartView.dataSeries = @[@[@(52), @(44), @(94), @(84), @(90)]];
    self.radarChartView.attributes = @[@"Add", @"defencse", @"spped", @"HP", @"MP"];
    self.radarChartView.coutArrs = @[@"", @"", @"", @"", @""];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShowMarkLabel:(BOOL)showMarkLabel
{
    _showMarkLabel = showMarkLabel;
    NSLog(@"%@",_showMarkLabel);
}


- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    NSArray* dataArr = dataModel.list;
    NSMutableArray* nameArr = [NSMutableArray array];
    NSMutableArray* valueArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++) {
        [nameArr addObject:dataArr[i][@"name"]];
        if (!dataArr[i][@"value"]) {
            [valueArr addObject:[[NSNumber alloc] initWithFloat:0.0f]];
        }else{
            [valueArr addObject:[[NSNumber alloc] initWithFloat:[dataArr[i][@"value"] floatValue]]];
        }
        
    }
    
    CGFloat widthF = kScreenWidth - 100;
    if (IS_IPHONE6P) {
        widthF = kScreenWidth - 120;
    }else{
        widthF = kScreenWidth - 100;
    }
    self.radarChartView = [[GYRRadarChart alloc] initWithFrame:CGRectMake(40, 30, widthF, widthF - 20)];
    self.radarChartView.dataSeries = @[valueArr];
    self.radarChartView.coutArrs = valueArr;
    self.radarChartView.maxValue = dataModel.max;
    self.radarChartView.attributes = nameArr;
    self.radarChartView.fillArea = YES;
    self.radarChartView.delegate   = self;
    
    self.radarChartView.showMarkLabel = dataModel.showValue;//是否显示分数
    
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.redarLab addSubview:self.radarChartView];
    
//    [self.radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.redarLab.mas_centerX);
//        make.centerY.equalTo(self.redarLab.mas_centerY);
//        make.top.equalTo(@20);
//        make.width.equalTo(self.radarChartView.mas_height);
//    }];
    
}



@end
