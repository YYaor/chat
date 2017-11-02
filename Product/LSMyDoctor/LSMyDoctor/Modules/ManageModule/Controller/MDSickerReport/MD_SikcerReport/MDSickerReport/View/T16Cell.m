//
//  T16Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/14.
//
//

#import "T16Cell.h"
#import "UUChart.h"

@interface T16Cell ()<UUChartDataSource>
{
    UUChart *chartView;
}
@property (weak, nonatomic) IBOutlet UIView *t16View;

@property (weak, nonatomic) IBOutlet UILabel *yLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *xLabelTag;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@property (nonatomic,copy) NSArray *xLabelsArr;
@property (nonatomic,copy) NSArray *yLabelsArr;
@property (nonatomic,copy) NSArray *yTextArray;
@property (nonatomic,copy) NSArray *stepArray;

@property (nonatomic,assign) NSInteger xMax;
@property (nonatomic,assign) NSInteger yMax;
@property (nonatomic,copy) NSArray *datas;//数据
//标记区域
@property (nonatomic,assign) NSInteger std_max;
@property (nonatomic,assign) NSInteger std_min;

@end

@implementation T16Cell

- (void)awakeFromNib{
    
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
        _legendView.hidden = YES;
        _topCon.constant = 0;
    }
    
    NSInteger datasNum = 7;
    if (_stepCount == 5) {
        
        datasNum = 30;
    }
    datasNum = _dataModel.xmax;
    
    _yMax = _dataModel.ymax;
    _std_max = dataModel.std_max;
    _std_min = dataModel.std_min;
    _xLabelTag.text = dataModel.xlabel;
    _yLabelTag.text = dataModel.ylabel;

    //x轴文字
    NSMutableArray *xmutArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= datasNum; ++i) {
        
        NSString *label = @"";
        for (NSDictionary *dict in _dataModel.abscissa) {
            
            if (i == [dict[@"coordinate"] integerValue]) {
                label = dict[@"label"];
            }
            
        }
        [xmutArr addObject:label];
    }
//    for (NSDictionary *dict in _dataModel.abscissa) {
//
//        [xmutArr addObject:dict[@"label"]];
//    }
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
    
    for (int i = 0; i <= datasNum; ++i) {
        
        NSString *value = @"";
        for (NSDictionary *dict in _dataModel.data) {
            if (i == [dict[@"x"] intValue]) {
                value = [NSString stringWithFormat:@"%ld",[dict[@"y"] integerValue]];
            }
        }
        [datasArr addObject:value];
    }
    _datas = datasArr;
    
    NSMutableArray *stepArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <= datasNum;++i) {
        if (i == 0) {
            [stepArr addObject:@"0"];
        }else{
            [stepArr addObject:@"1"];
        }
    }
    _stepArray = stepArr;


    [self configUI:_path LinesArray:_yLabelsArr StepCount:_stepCount];
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
    chartView.yValuesArray = linesArray;
    chartView.yTextArray = _yTextArray;
    chartView.lines=lines==0?1:lines;
    chartView.StepCount=stepcount==0?1:stepcount;
    [chartView showInView:_t16View];
}

#pragma mark - @required
- (NSArray *)UUChart_xStepArray:(UUChart *)chart
{
//    if (_isSetXStepArray) {//不返回值，则采用传入的默认不进值（chartView.StepCount）
//        return @[@"0",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
//        //return _xStepArray;//第一个值步进为0
//    }
    return _stepArray;
    return nil;
}
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    return _xLabelsArr;

}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    return @[_datas];//数据为空时，不连续，不能设置为0。
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UULinecolor,UUYellow,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    NSInteger maxValue = [[_yLabelsArr lastObject] integerValue];
    NSInteger minValue = [[_yLabelsArr firstObject] integerValue];
    return CGRangeMake(maxValue, minValue);

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

//判断显示最大最小值
//- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
//{
//    return path.row==2;
//}
@end
