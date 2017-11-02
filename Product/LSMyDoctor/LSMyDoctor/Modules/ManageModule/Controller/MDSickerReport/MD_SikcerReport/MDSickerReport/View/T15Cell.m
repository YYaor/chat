//
//  T15Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import "T15Cell.h"
#import "UUChart.h"

@interface T15Cell ()<UUChartDataSource>
{
    UUChart *chartView;
}

@property (weak, nonatomic) IBOutlet UIView *t15View;

@property (weak, nonatomic) IBOutlet UILabel *yLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *xLabelTag;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel1;

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *controlFrontLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *controlLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t15ViewTopCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t15ViewHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewCon;//顶部视图高度
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic,copy) NSArray *xLabelsArr;
@property (nonatomic,copy) NSArray *yLabelsArr;
@property (nonatomic,copy) NSArray *yTextArray;
@property (nonatomic,copy) NSArray *colorsArray;
@property (nonatomic,copy) NSArray *xStepArray;//x轴步进值
@property (nonatomic,assign) NSInteger xMax;
@property (nonatomic,assign) NSInteger yMax;
@property (nonatomic,copy) NSArray *datas;//数据
//标记区域
@property (nonatomic,assign) NSInteger std_max;
@property (nonatomic,assign) NSInteger std_min;

@end

@implementation T15Cell

- (void)awakeFromNib{
    
    _controlFrontLabel.layer.masksToBounds = YES;
    _controlFrontLabel.layer.cornerRadius = 5;
    
    [_detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.cornerRadius = 5;
    [_detailBtn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    _detailBtn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
}

//- (void)setDataModel:(ReportItemDataModel *)dataModel{
- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    self.dataModel = itemModel.data;
}
//详情按钮点击事件
- (IBAction)detailBtnClicked:(id)sender {
    
    _detailBlock(_dataModel.detail);
}
    
- (void)setDataModel:(ReportItemDataModel *)dataModel{
    _dataModel = dataModel;
    
    if (_control) {
        _captionLabel.hidden = YES;
        _detailBtn.hidden = YES;
        _t15ViewTopCon.constant = 30;
        _t15ViewHeightCon.constant = 270;
        _controlLabel.text = _control.text;
    }else{
        
        if (_itemModel.caption) {
            _captionLabel.hidden = NO;
            _headerViewCon.constant = 40;
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
            _t15ViewTopCon.constant = 40;
            _t15ViewHeightCon.constant = 260;
        }else if (dataModel.detail && !_isMonthReport) {
//            _headerViewCon.constant = 40;
            _controlLabel.hidden = YES;
            _controlFrontLabel.hidden = YES;
            _captionLabel.hidden = YES;
            _detailBtn.hidden = NO;
            _topView.backgroundColor = [UIColor clearColor];
            [self.contentView bringSubviewToFront:_topView];
            _t15ViewTopCon.constant = 10;
            _headerViewCon.constant = 40;
            _t15ViewHeightCon.constant = 310;
        }else{
            _captionLabel.hidden = YES;
            _detailBtn.hidden = YES;
            _t15ViewTopCon.constant = 0;
            _t15ViewHeightCon.constant = 300;
        }
        
    }
    
    _yMax = _dataModel.ymax;
//    _std_max = dataModel.std_max;
//    _std_min = dataModel.std_min;
    _xLabelTag.text = dataModel.xlabel;
    _yLabelTag.text = dataModel.ylabel;
    
    if (_width > 0) {
        _bottomCon.constant = 10;
    }
    
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
                NSString *text1 = dict[@"label"];
                if (text1.length > 0) {
                    _textLabel1.text = dict[@"label"];
                }else{
                    _textLabel1.text = @"";
                }
                
            }else{
                
                if ([dict[@"color"] integerValue] == 1) {
                    _colorLabel2.backgroundColor = UULinecolor;
                }else{
                    _colorLabel2.backgroundColor = UUYellow;
                }
                NSString *text2 = dict[@"label"];
                if (text2.length > 0) {
                    _textLabel2.text = dict[@"label"];
                }else{
                    _textLabel2.text = @"";
                }
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
    NSMutableArray *xStepArr = [[NSMutableArray alloc] init];
    NSInteger num = _dataModel.abscissa.count;
    if (_isYearReport) {
        num = 12;
    }
    for (int i = 0; i < num; ++i) {
        
        
        if (_isYearReport) {
            
            NSString *label = @"";
            for (NSDictionary *dict in _dataModel.abscissa) {
                if (i == [dict[@"coordinate"] integerValue]) {
                    label = dict[@"label"];
                }
            }
            
            [xmutArr addObject:label];
        }else{
            
            NSDictionary *dict = _dataModel.abscissa[i];
            [xmutArr addObject:dict[@"label"]];
            if (i > 0) {
                
                NSDictionary *preDict = _dataModel.abscissa[i - 1];
                [xStepArr addObject:@([dict[@"coordinate"] integerValue] - [preDict[@"coordinate"] integerValue])];
                
            }else{
                [xStepArr addObject:dict[@"coordinate"]];
            }
        }
    }
    _xLabelsArr = xmutArr;
    if (_isSetXStepArray) {
        _xStepArray = xStepArr;
    }
    
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
    }else if(_isYearReport){
        datasNum = 12;
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
        
        if (_control) {
            chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, self.width, self.height - 30)
                                                      withSource:self
                                                       withStyle:UUChartLineStyle];
        }else{
            
            chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, self.width, self.height)
                                                  withSource:self
                                                   withStyle:UUChartLineStyle];
        }
    }else{
        
        if (_itemModel.caption) {
            
            chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, kScreenWidth - 30, 280 - 40)
                                                      withSource:self
                                                       withStyle:UUChartLineStyle];
        }else{
            
            chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 20, kScreenWidth - 30, 280)
                                                      withSource:self
                                                       withStyle:UUChartLineStyle];
        }
        
    }
    chartView.colorsArray = _colorsArray;
    NSInteger lines = linesArray.count;
    chartView.yValuesArray = linesArray;
    chartView.yTextArray = _yTextArray;
    chartView.lines=lines==0?1:lines;
    chartView.StepCount=stepcount==0?1:stepcount;
    [chartView showInView:_t15View];
}

#pragma mark - @required
//步进数组===============特殊处理
- (NSArray *)UUChart_xStepArray:(UUChart *)chart
{
    if (_isSetXStepArray) {//不返回值，则采用传入的默认不进值（chartView.StepCount）
        return @[@"0",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
        //return _xStepArray;//第一个值步进为0
    }
    return nil;
}

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    //return @[@"2",@"3",@"",@"5",@"",@"7",@"",@"9",@"",@"11",@"",@"1"];
    return _xLabelsArr;
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    //return @[@[@"20",@"",@"27",@"33",@"48",@"24",@"39",@"33",@"50",@"24",@"49",@"33"]];
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
