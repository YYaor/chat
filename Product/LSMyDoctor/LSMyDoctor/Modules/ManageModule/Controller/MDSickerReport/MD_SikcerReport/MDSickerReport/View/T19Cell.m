//
//  T19Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/15.
//
//

#import "T19Cell.h"
#import "UUChart.h"

@interface T19Cell ()<UUChartDataSource>
{
    UUChart *chartView;
}

@property (weak, nonatomic) IBOutlet UIView *t19View;

@property (weak, nonatomic) IBOutlet UILabel *yLabelTag;//y轴单位
@property (weak, nonatomic) IBOutlet UILabel *xLabelTag;//x轴单位

@property (strong, nonatomic)UILabel *colorLabel1;
@property (strong, nonatomic)UILabel *textlabel1;
@property (strong, nonatomic)UILabel *colorLabel2;
@property (strong, nonatomic)UILabel *textlabel2;

@property (strong, nonatomic)UILabel *qujianColorLabel1;
@property (strong, nonatomic)UILabel *qujianTextLabel1;
@property (strong, nonatomic)UILabel *qujianColorLabel2;
@property (strong, nonatomic)UILabel *qujianTextLabel2;

@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon2;//图表顶部约束

@property (nonatomic,copy) NSArray *xLabelsArr;
@property (nonatomic,copy) NSArray *yLabelsArr;
@property (nonatomic,copy) NSArray *yTextArray;
@property (nonatomic,copy) NSArray *stepArray;

@property (nonatomic,assign) NSInteger xMax;
@property (nonatomic,assign) NSInteger yMax;
@property (nonatomic,copy) NSArray *datas;//数据
//标记区域
@property (nonatomic,assign) NSInteger hi_std_max;
@property (nonatomic,assign) NSInteger hi_std_min;
@property (nonatomic,assign) NSInteger lo_std_max;
@property (nonatomic,assign) NSInteger lo_std_min;


@end

@implementation T19Cell

- (void)awakeFromNib {
    // Initialization code
    
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
    [_colorLabel1 removeFromSuperview];
    [_textlabel1 removeFromSuperview];
    [_colorLabel2 removeFromSuperview];
    [_textlabel2 removeFromSuperview];
    [_qujianColorLabel1 removeFromSuperview];
    [_qujianColorLabel2 removeFromSuperview];
    [_qujianTextLabel1 removeFromSuperview];
    [_qujianTextLabel2 removeFromSuperview];
    
    if (_itemModel.caption) {
        _legendView.hidden = NO;
        _topCon2.constant = 40;
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
        _topCon2.constant = 0;
    }
    
    _yMax = _dataModel.ymax;
    //标记区域
    _hi_std_max = dataModel.hi_std_max;
    _hi_std_min = dataModel.hi_std_min;
    _lo_std_max = dataModel.lo_std_max;
    _lo_std_min = dataModel.lo_std_min;
    //横纵坐标单位
    _xLabelTag.text = dataModel.xlabel;
    _yLabelTag.text = dataModel.ylabel;
    
    //标记值    UIColorHex(@"FFB434"),UIColorHex(@"4dd0e1")
    if (dataModel.legend.count > 0) {
        
        _colorLabel1 = [[UILabel alloc] init];
        [self.t19View addSubview:_colorLabel1];
        _colorLabel1.layer.masksToBounds = YES;
        _colorLabel1.layer.cornerRadius = 5;
        
        _textlabel1 = [[UILabel alloc] init];
        _textlabel1.font = [UIFont systemFontOfSize:10];
        [self.t19View addSubview:_textlabel1];
        
        _colorLabel2 = [[UILabel alloc] init];
        [self.t19View addSubview:_colorLabel2];
        _colorLabel2.layer.masksToBounds = YES;
        _colorLabel2.layer.cornerRadius = 5;
        
        _textlabel2 = [[UILabel alloc] init];
        _textlabel2.font = [UIFont systemFontOfSize:10];
        [self.t19View addSubview:_textlabel2];
        
        NSArray *legend = dataModel.legend;
        
        __block typeof(self) blockSelf = self;
        
        if (dataModel.hi_std_max == 0 || dataModel.lo_std_max) {
            
            //不带区间
            [_textlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.t19View.mas_right).offset(-20);
                make.top.equalTo(blockSelf.t19View.mas_top).offset(5);
            }];
            [_colorLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.textlabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.textlabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
            [_textlabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.colorLabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.textlabel2.mas_top);
            }];
            [_colorLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.textlabel1.mas_left).offset(-5);
                make.top.equalTo(blockSelf.textlabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
        }else{
        
            _qujianColorLabel1 = [[UILabel alloc] init];
            [self.t19View addSubview:_qujianColorLabel1];
            _qujianTextLabel1 = [[UILabel alloc] init];
            _qujianTextLabel1.font = [UIFont systemFontOfSize:10];
            [self.t19View addSubview:_qujianTextLabel1];
            _qujianColorLabel2 = [[UILabel alloc] init];
            [self.t19View addSubview:_qujianColorLabel2];
            _qujianTextLabel2 = [[UILabel alloc] init];
            _qujianTextLabel2.font = [UIFont systemFontOfSize:10];
            [self.t19View addSubview:_qujianTextLabel2];
            
            //带区间
            [_qujianTextLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.t19View.mas_right).offset(-20);
                make.top.equalTo(blockSelf.t19View.mas_top).offset(5);
            }];
            [_qujianColorLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.qujianTextLabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(20, 10));
            }];
            [_qujianTextLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.qujianColorLabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
            }];
            [_qujianColorLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.qujianTextLabel1.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(20, 10));
            }];
            
            [_textlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.qujianColorLabel1.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
            }];
            [_colorLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.textlabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
            [_textlabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.colorLabel2.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
            }];
            [_colorLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(blockSelf.textlabel1.mas_left).offset(-5);
                make.top.equalTo(blockSelf.qujianTextLabel2.mas_top);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
        }
        
        for (int i = 0; i < legend.count; ++i) {
            
            NSDictionary *dict = legend[i];
            if (i == 0) {
                
                if ([dict[@"color"] integerValue] == 1) {
                    _colorLabel1.backgroundColor = UULinecolor;
                    _qujianColorLabel1.backgroundColor = UULinecolor;
                }else{
                    _colorLabel1.backgroundColor = UUYellow;
                    _qujianColorLabel1.backgroundColor = UUYellow;
                }
                _textlabel1.text = dict[@"label"];
                _qujianTextLabel1.text = [NSString stringWithFormat:@"%@区间",dict[@"label"]];

            }else{
                if ([dict[@"color"] integerValue] == 1) {
                    _colorLabel2.backgroundColor = UULinecolor;
                    _qujianColorLabel2.backgroundColor = UULinecolor;
                }else{
                    _colorLabel2.backgroundColor = UUYellow;
                    _qujianColorLabel2.backgroundColor = UUYellow;
                }
                _textlabel2.text = dict[@"label"];
                _qujianTextLabel2.text = [NSString stringWithFormat:@"%@区间",dict[@"label"]];
            }
        }

        
    }else{
        
        _colorLabel1.hidden = YES;
        _textlabel1.hidden = YES;
        _colorLabel2.hidden = YES;
        _textlabel2.hidden = YES;
        _qujianColorLabel1.hidden = YES;
        _qujianColorLabel2.hidden = YES;
        _qujianTextLabel1.hidden = YES;
        _qujianTextLabel2.hidden = YES;
    }
   
    if (_width > 0) {
        _bottomCon.constant = 10;
    }
    
    NSInteger datasNum = 7;
    if (_stepCount == 5) {
        
        datasNum = 30;
    }
    datasNum = _dataModel.xmax;
    
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
    _xLabelsArr = xmutArr;
//    for (NSDictionary *dict in _dataModel.abscissa) {
//        
//        [xmutArr addObject:dict[@"label"]];
//    }
//    _xLabelsArr = xmutArr;
    
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
    
    
    NSMutableArray *hiDatas = [[NSMutableArray alloc] init];
    NSMutableArray *loDatas = [[NSMutableArray alloc] init];
    for (int i = 0; i <= datasNum; ++i) {
        NSString *hiValue = @"";
        for (NSDictionary *dict in _dataModel.hi_data) {
            if (i == [dict[@"x"] intValue]) {
                hiValue = [NSString stringWithFormat:@"%ld",[dict[@"y"] integerValue]];
            }
        }
        [hiDatas addObject:hiValue];
        
        NSString *loValue = @"";
        for (NSDictionary *dict in _dataModel.lo_data) {
            if (i == [dict[@"x"] intValue]) {
                loValue = [NSString stringWithFormat:@"%ld",[dict[@"y"] integerValue]];
            }
        }
        [loDatas addObject:loValue];
        
    }
    [datasArr addObjectsFromArray:@[hiDatas,loDatas]];
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
    [chartView showInView:_t19View];
    
    [self.contentView bringSubviewToFront:_colorLabel1];
    [self.contentView bringSubviewToFront:_textlabel1];
    [self.contentView bringSubviewToFront:_colorLabel2];
    [self.contentView bringSubviewToFront:_textlabel2];
    [self.contentView bringSubviewToFront:_qujianColorLabel1];
    [self.contentView bringSubviewToFront:_qujianTextLabel1];
    [self.contentView bringSubviewToFront:_qujianColorLabel2];
    [self.contentView bringSubviewToFront:_qujianTextLabel2];
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
    return _datas;//数据为空时，不连续，不能设置为0。
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    if (_dataModel.hi_data.count > 0 && _dataModel.lo_data.count > 0) {
        NSMutableArray *colorsArray = [[NSMutableArray alloc] init];
        NSDictionary *hi_legend = _dataModel.hi_data[0];
        if ([hi_legend[@"color"] integerValue] == 1) {
            [colorsArray addObject:UULinecolor];
        }else{
            [colorsArray addObject:UUYellow];
        }
        
        if (_dataModel.lo_data.count != 0) {
            NSDictionary *lo_legend = _dataModel.lo_data[0];
            if ([lo_legend[@"color"] integerValue] == 1) {
                [colorsArray addObject:UULinecolor];
            }else{
                [colorsArray addObject:UUYellow];
            }
        }
                
        return colorsArray;
    }else{
        return @[UULinecolor,UUYellow,UUBrown];
    }
//    return @[UULinecolor,UUYellow,UUBrown];
}
//显示区间数值范围
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
    return @[@[@(_hi_std_min),@(_hi_std_max)],@[@(_lo_std_min),@(_lo_std_max)]];
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
