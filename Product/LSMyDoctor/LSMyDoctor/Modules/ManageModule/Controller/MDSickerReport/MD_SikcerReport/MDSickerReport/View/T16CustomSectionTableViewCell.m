//
//  T16CustomSectionTableViewCell.m
//  YouGeHealth
//
//  Created by MagicBeans2 on 17/1/22.
//
//

#import "T16CustomSectionTableViewCell.h"
#import "UUChart.h"

@interface T16CustomSectionTableViewCell ()<UUChartDataSource>
{
    UUChart *chartView;
    
}
@property (nonatomic,copy) NSArray *xLabelsArr;
@property (nonatomic,copy) NSArray *yLabelsArr;
@property (nonatomic,copy) NSArray *yTextArray;
@property (nonatomic,assign) NSInteger xMax;
@property (nonatomic,assign) NSInteger yMax;
@property (nonatomic,copy) NSArray *datas;//数据

@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

//标记区域
@property (nonatomic,assign) NSInteger std_max;
@property (nonatomic,assign) NSInteger std_min;

@property (weak, nonatomic) IBOutlet UIView *t16View;

@property (weak, nonatomic) IBOutlet UILabel *yLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *xLabelTag;

@property (nonatomic,copy) NSMutableArray *topArr;
@property (nonatomic,copy) NSMutableArray *bottomArr;
@property (nonatomic,copy) NSMutableArray *yValueArr;
@property (nonatomic,assign) CGPoint redPoint;
@property (nonatomic,copy) NSArray *redPointArr;
@end
@implementation T16CustomSectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _topArr=[NSMutableArray array];
     _bottomArr=[NSMutableArray array];
    _yValueArr=[NSMutableArray array];
    
    [_detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.cornerRadius = 5;
    [_detailBtn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    _detailBtn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
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
            _captionLabel.textColor = UIColorFromRGB(0x008fed);
            _captionLabel.textAlignment = NSTextAlignmentLeft;
            _captionLabel.text = [NSString stringWithFormat:@"    %@",_itemModel.caption.text];
        }else{
            //居中
            _captionLabel.backgroundColor = RGBCOLOR(207, 245, 222);
            _captionLabel.textColor = Style_Color_Content_Black;
            _captionLabel.textAlignment = NSTextAlignmentCenter;
            _captionLabel.text = _itemModel.caption.text;
        }
    }else{
        _legendView.hidden = YES;
        _topCon.constant = 0;
    }
    
    _yNameLbl.text = dataModel.ylabel;

    NSMutableArray *xNameArr = [[NSMutableArray alloc] init];
    for (NSDictionary * xDic in dataModel.abscissa) {
        [xNameArr addObject:[NSString stringWithFormat:@"%@",xDic[@"label"]]];
    }
    _xLabelsArr=xNameArr;
    
    NSMutableArray *yNameArr = [[NSMutableArray alloc] init];
    NSMutableArray *yValuesArr = [[NSMutableArray alloc] init];
    for (NSDictionary * yDic in dataModel.ordinate) {
        [yNameArr addObject:[NSString stringWithFormat:@"%@",yDic[@"label"]]];
        [yValuesArr addObject:[NSString stringWithFormat:@"%@",yDic[@"coordinate"]]];
    }
    _yLabelsArr=yNameArr;
    _yValueArr = yValuesArr;
    NSMutableArray * marray =[NSMutableArray array];
    for (NSDictionary * dDic in dataModel.data) {
        //                    [topArr addObject:[NSString stringWithFormat:@"%@",dDic[@"max"]]];
        [marray addObject:[NSString stringWithFormat:@"%@",dDic[@"min"]]];
        
    }
    NSMutableArray *tempData=[NSMutableArray arrayWithArray:dataModel.data];
    NSMutableArray *topArr = [[NSMutableArray alloc] init];
    NSMutableArray *myredPointArr = [[NSMutableArray alloc] init];
    for (int i =0; i<[tempData count]; i++) {
        [topArr addObject:[NSValue valueWithCGPoint:CGPointMake(i, [(tempData[i][@"max"])intValue])]];
        //值
        if ([tempData[i][@"y"] integerValue]>0) {
            
            CGPoint myredPoint=CGPointMake(i, [(tempData[i][@"y"]) integerValue]);
            [myredPointArr addObject:NSStringFromCGPoint(myredPoint)];
        }
    }
    _redPointArr = myredPointArr;
    _topArr = topArr;
    //                [NSValue valueWithCGPoint:CGPointMake(0, 180)]
    //  进行排序
    NSMutableArray *bottomArr = [[NSMutableArray alloc] init];
    NSMutableArray *bottomTempArr=[NSMutableArray array];
    bottomTempArr=[NSMutableArray arrayWithArray:[[marray reverseObjectEnumerator] allObjects]];
    for (int i =0; i<[bottomTempArr count]; i++) {
        //                    [bottomArr addObject:[NSValue valueWithCGPoint:CGPointMake([bottomTempArr count]-i-1, [(tempData[i][@"min"])intValue])]];
        [bottomArr addObject:[NSValue valueWithCGPoint:CGPointMake([bottomTempArr count]-i-1, [(bottomTempArr[i])intValue])]];
    }
    _bottomArr = bottomArr;
    
    

//    _topArr=@[[NSValue valueWithCGPoint:CGPointMake(0, 77550)],
//              [NSValue valueWithCGPoint:CGPointMake(1, 77580)],
//              [NSValue valueWithCGPoint:CGPointMake(2, 77610)],
//              [NSValue valueWithCGPoint:CGPointMake(3, 77640)],
//              [NSValue valueWithCGPoint:CGPointMake(4, 77670)],
//              [NSValue valueWithCGPoint:CGPointMake(5, 77700)],
//              [NSValue valueWithCGPoint:CGPointMake(6, 77730)],
//              [NSValue valueWithCGPoint:CGPointMake(7, 77760)],
//              [NSValue valueWithCGPoint:CGPointMake(8, 77790)],
//              [NSValue valueWithCGPoint:CGPointMake(9, 77820)],
//              [NSValue valueWithCGPoint:CGPointMake(10, 77850)],
//              [NSValue valueWithCGPoint:CGPointMake(11, 77880)],
//              [NSValue valueWithCGPoint:CGPointMake(12, 77910)],
//              [NSValue valueWithCGPoint:CGPointMake(13, 77940)],
//              [NSValue valueWithCGPoint:CGPointMake(14, 77970)],
//              [NSValue valueWithCGPoint:CGPointMake(15, 78000)],
//              [NSValue valueWithCGPoint:CGPointMake(16, 78030)],
//              [NSValue valueWithCGPoint:CGPointMake(17, 78060)],
//              [NSValue valueWithCGPoint:CGPointMake(18, 78090)],
//              [NSValue valueWithCGPoint:CGPointMake(19, 78120)],
//              [NSValue valueWithCGPoint:CGPointMake(20, 78150)],
//              [NSValue valueWithCGPoint:CGPointMake(21, 78180)],
//              [NSValue valueWithCGPoint:CGPointMake(22, 78210)],
//              [NSValue valueWithCGPoint:CGPointMake(23, 78240)],
//              [NSValue valueWithCGPoint:CGPointMake(24, 78270)],
//              [NSValue valueWithCGPoint:CGPointMake(25, 78300)],
//              [NSValue valueWithCGPoint:CGPointMake(26, 78367)],
//              [NSValue valueWithCGPoint:CGPointMake(27, 78434)],
//              [NSValue valueWithCGPoint:CGPointMake(28, 78501)],
//              [NSValue valueWithCGPoint:CGPointMake(29, 78568)]];
//    _bottomArr=@[[NSValue valueWithCGPoint:CGPointMake(29, 77220)],
//                 [NSValue valueWithCGPoint:CGPointMake(28, 77155)],
//                 [NSValue valueWithCGPoint:CGPointMake(27, 77090)],
//                 [NSValue valueWithCGPoint:CGPointMake(26, 77025)],
//                 [NSValue valueWithCGPoint:CGPointMake(25, 76960)],
//                 [NSValue valueWithCGPoint:CGPointMake(24, 76923)],
//                 [NSValue valueWithCGPoint:CGPointMake(23, 76886)],
//                 [NSValue valueWithCGPoint:CGPointMake(22, 76849)],
//                 [NSValue valueWithCGPoint:CGPointMake(21, 76812)],
//                 [NSValue valueWithCGPoint:CGPointMake(20, 76775)],
//                 [NSValue valueWithCGPoint:CGPointMake(19, 76738)],
//                 [NSValue valueWithCGPoint:CGPointMake(18, 76701)],
//                 [NSValue valueWithCGPoint:CGPointMake(17, 76664)],
//                 [NSValue valueWithCGPoint:CGPointMake(16, 76627)],
//                 [NSValue valueWithCGPoint:CGPointMake(15, 76590)],
//                 [NSValue valueWithCGPoint:CGPointMake(14, 76553)],
//                 [NSValue valueWithCGPoint:CGPointMake(13, 76516)],
//                 [NSValue valueWithCGPoint:CGPointMake(12, 76479)],
//                 [NSValue valueWithCGPoint:CGPointMake(11, 76442)],
//                 [NSValue valueWithCGPoint:CGPointMake(10, 76405)],
//                 [NSValue valueWithCGPoint:CGPointMake(9, 76368)],
//                 [NSValue valueWithCGPoint:CGPointMake(8, 76331)],
//                 [NSValue valueWithCGPoint:CGPointMake(7, 76294)],
//                 [NSValue valueWithCGPoint:CGPointMake(6, 76257)],
//                 [NSValue valueWithCGPoint:CGPointMake(5, 76220)],
//                 [NSValue valueWithCGPoint:CGPointMake(4, 76183)],
//                 [NSValue valueWithCGPoint:CGPointMake(3, 76146)],
//                 [NSValue valueWithCGPoint:CGPointMake(2, 76109)],
//                 [NSValue valueWithCGPoint:CGPointMake(1, 76072)],
//                 [NSValue valueWithCGPoint:CGPointMake(0, 76035)]];
//    _yValueArr=@[@"68440",@"72360",@"76280",@"80200",@"84120",@"88040"];
//    _redPoint=CGPointMake(14, 80000);
    [self configUI:_path LinesArray:_yLabelsArr StepCount:1];
}

-(void)initViewWithTopArr:(NSMutableArray *)topArr bottomArr:(NSMutableArray *)bottomArr xlineArr:(NSMutableArray *)xlineArr yLineArr:(NSMutableArray *)yLineArr yValueArr:(NSMutableArray *)yValueArr currentData:(CGPoint)redPoint{
    
    _legendView.hidden = YES;
    _topCon.constant = 0;
    
    _xLabelsArr=xlineArr;
    _yLabelsArr=yLineArr;
    _topArr=topArr;
    _bottomArr=bottomArr;
    _yValueArr=yValueArr;
    _redPoint=redPoint;
    _redPointArr = @[NSStringFromCGPoint(_redPoint)];
    [self configUI:_path LinesArray:yLineArr StepCount:1];
}

- (void)configUI:(NSIndexPath *)indexPath LinesArray:(NSArray *)linesArray StepCount:(NSInteger)stepcount
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    if (self.width>0&&self.height>0) {
        chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, self.width, self.height)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
    }else{
        chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, kScreenWidth-30, 280)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
    }
    NSInteger lines = linesArray.count;
    chartView.nums = _nums;
    chartView.yValuesArray = _yValueArr;
    chartView.yTextArray = linesArray;
    chartView.lines=lines==0?1:lines;
    chartView.StepCount=stepcount==0?1:stepcount;
    chartView.isCustomSection=YES;
    chartView.redPointArr=_redPointArr;
//    chartView.topArr=[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 180)],[NSValue valueWithCGPoint:CGPointMake(1, 130)],[NSValue valueWithCGPoint:CGPointMake(2, 160)], nil];
//    chartView.bottomArr=[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(2, 120)],[NSValue valueWithCGPoint:CGPointMake(1, 100)],[NSValue valueWithCGPoint:CGPointMake(0, 71)], nil];
    chartView.topArr=_topArr;
    chartView.bottomArr=_bottomArr;
    [chartView showInView:_t16View];
}

#pragma mark - @required
- (NSArray *)UUChart_xStepArray:(UUChart *)chart
{
    //    if (_isSetXStepArray) {//不返回值，则采用传入的默认不进值（chartView.StepCount）
    //        return @[@"0",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    //        //return _xStepArray;//第一个值步进为0
    //    }
    return nil;
}
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return _xLabelsArr;
//    return @[@"8.1",@"",@"",@"",@"",@"8.6",@"8.7",@"8.8",@"8.9",@"8.10",@"8.11",@"8.12",@"8.13",@"8.14",@"8.15",@"8.16",@"8.17",@"8.18",@"8.19",@"8.20",@"8.21",@"8.22",@"8.23",@"8.24",@"8.25",@"8.26",@"8.27",@"8.28",@"8.29",@"8.30"];
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
//    return @[_datas];//数据为空时，不连续，不能设置为0。
   return @[@[@"",@"",@"",@"",@"",@"",@""]];
//    return @[_pointArr];
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UIColorFromRGB(0xff582d),UUYellow,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    NSInteger maxValue = [[_yValueArr lastObject] integerValue];
    NSInteger minValue = [[_yValueArr firstObject] integerValue];
    return CGRangeMake(maxValue, minValue);
//    return CGRangeMake(200, 40);
    
}

#pragma mark 折线图专享功能

//标记数，数组值区域
- (NSArray *)UUChartMarkRangeInLineCharts:(UUChart *)chart
{
    
    return @[@[@(_std_min),@(_std_max)]];
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
/*
- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    _yMax = _dataModel.ymax;
    _std_max = dataModel.std_max;
    _std_min = dataModel.std_min;
    _xLabelTag.text = dataModel.xlabel;
    _yLabelTag.text = dataModel.ylabel;
    
    //x轴文字
    NSMutableArray *xmutArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _dataModel.abscissa) {
        
        [xmutArr addObject:dict[@"label"]];
    }
    _xLabelsArr = xmutArr;
    
    //y轴值
    NSMutableArray *ymutArr = [[NSMutableArray alloc] init];
    //y轴文字
    NSMutableArray *yTextArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _dataModel.ordinate) {
        
        [ymutArr addObject:dict[@"coordinate"]];
        [yTextArr addObject:dict[@"label"]];
    }
    _yLabelsArr = ymutArr;
    _yTextArray = yTextArr;
    
    //value值
    NSMutableArray *datasArr = [[NSMutableArray alloc] init];
    
    //    int datasNum = 7;
    NSInteger datasNum = _xLabelsArr.count;
    if (_stepCount == 5) {
        
        datasNum = 30;
    }
    for (int i = 0; i < datasNum; ++i) {
        
        NSString *value = @"";
        for (NSDictionary *dict in _dataModel.data) {
            if (i == [dict[@"x"] intValue]) {
                value = [NSString stringWithFormat:@"%ld",[dict[@"y"] integerValue]];
            }
        }
        [datasArr addObject:value];
    }
    _datas = datasArr;
    
    [self configUI:_path LinesArray:_yLabelsArr StepCount:_stepCount];
}*/
@end
