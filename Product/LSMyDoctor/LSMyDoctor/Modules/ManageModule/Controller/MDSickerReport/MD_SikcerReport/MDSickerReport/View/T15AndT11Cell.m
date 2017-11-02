//
//  T15AndT11Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/29.
//
//

#import "T15AndT11Cell.h"
#import "UUChart.h"

@interface T15AndT11Cell ()<UUChartDataSource>
{
    UUChart *chartView;
}

@property (weak, nonatomic) IBOutlet UIView *t15AndT11View;

@property (weak, nonatomic) IBOutlet UILabel *yLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *xLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel1;

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;

@property (weak, nonatomic) IBOutlet UILabel *textContentLabel;

@property (nonatomic,copy) NSArray *xLabelsArr;
@property (nonatomic,copy) NSArray *yLabelsArr;
@property (nonatomic,copy) NSArray *yTextArray;
@property (nonatomic,copy) NSArray *colorsArray;
@property (nonatomic,assign) NSInteger xMax;
@property (nonatomic,assign) NSInteger yMax;
@property (nonatomic,copy) NSArray *datas;//数据
//标记区域
@property (nonatomic,assign) NSInteger std_max;
@property (nonatomic,assign) NSInteger std_min;

@end

@implementation T15AndT11Cell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    NSString * cLabelString = [NSString stringWithFormat:@"        %@",_textStr];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:cLabelString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [cLabelString length])];
    [_textContentLabel setAttributedText:attributedString1];
    
    _dataModel = dataModel;
    _yMax = _dataModel.ymax;
    //    _std_max = dataModel.std_max;
    //    _std_min = dataModel.std_min;
    _xLabelTag.text = dataModel.xlabel;
    _yLabelTag.text = dataModel.ylabel;
    
//    if (_width > 0) {
//        _bottomCon.constant = 10;
//    }
    
    //标记值    UIColorHex(@"FFB434"),UIColorHex(@"4dd0e1")
    if (dataModel.legend.count > 0) {
        
        NSArray *legend = dataModel.legend;
        _colorLabel1.hidden = NO;
        _colorLabel1.layer.masksToBounds = YES;
        _colorLabel1.layer.cornerRadius = 5;
        _textLabel1.hidden = NO;
        _colorLabel2.hidden = NO;
        _colorLabel2.layer.masksToBounds = YES;
        _colorLabel2.layer.cornerRadius = 5;
        _textLabel2.hidden = NO;
        
        for (int i = 0; i < legend.count; ++i) {
            
            NSDictionary *dict = legend[i];
            if (i == 0) {
                
                if ([dict[@"color"] integerValue] == 1) {
                    _colorLabel1.backgroundColor = UULinecolor;
                }else{
                    _colorLabel1.backgroundColor = UUYellow;
                }
                _textLabel1.text = dict[@"label"];
                
            }else{
                
                if ([dict[@"color"] integerValue] == 1) {
                    _colorLabel2.backgroundColor = UULinecolor;
                }else{
                    _colorLabel2.backgroundColor = UUYellow;
                }
                _textLabel2.text = dict[@"label"];
            }
        }
        
    }else{
        
        _colorLabel1.hidden = YES;
        _textLabel1.hidden = YES;
        _colorLabel2.hidden = YES;
        _textLabel2.hidden = YES;
    }
    
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
    //点颜色的值
    NSMutableArray *colorsArr = [[NSMutableArray alloc] init];
    int datasNum = 7;
    if (_stepCount == 5) {
        
        datasNum = 30;
    }
    for (int i = 0; i < datasNum; ++i) {
        
        NSString *value = @"";
        NSString *color = @"";
        for (NSDictionary *dict in _dataModel.data) {
            if (i == [dict[@"x"] intValue]) {
                value = [NSString stringWithFormat:@"%ld",[dict[@"y"] integerValue]];
                color = [NSString stringWithFormat:@"%ld",[dict[@"color"] integerValue]];
            }
        }
        [colorsArr addObject:color];
        [datasArr addObject:value];
    }
    _colorsArray = colorsArr;
    _datas = datasArr;
    
    
    [self configUI:_path LinesArray:_yLabelsArr StepCount:_stepCount];
}

- (void)configUI:(NSIndexPath *)indexPath LinesArray:(NSArray *)linesArray StepCount:(NSInteger)stepcount
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    if (self.width>0&&self.height>0) {
        chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, self.width, self.height - 50)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
    }
    chartView.colorsArray = _colorsArray;
    chartView.backgroundColor = [UIColor clearColor];
    NSInteger lines = linesArray.count;
    chartView.yValuesArray = linesArray;
    chartView.yTextArray = _yTextArray;
    chartView.lines=lines==0?1:lines;
    chartView.StepCount=stepcount==0?1:stepcount;
    [chartView showInView:_t15AndT11View];
    
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

////标记数，数组值区域
//- (NSArray *)UUChartMarkRangeInLineCharts:(UUChart *)chart
//{
//
//    return @[@[@(_std_min),@(_std_max)]];
//}

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
