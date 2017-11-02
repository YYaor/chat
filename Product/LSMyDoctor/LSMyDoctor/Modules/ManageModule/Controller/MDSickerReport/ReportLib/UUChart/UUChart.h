//
//  UUChart.h
//	Version 0.1
//  UUChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
#import "UUColor.h"
#import "UULineChart.h"
#import "UUBarChart.h"
//类型
typedef enum {
	UUChartLineStyle,
	UUChartBarStyle
} UUChartStyle;


@class UUChart;
@protocol UUChartDataSource <NSObject>

@required
//步进数组
- (NSArray *)UUChart_xStepArray:(UUChart *)chart;

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart;

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart;

@optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart;

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart;

//标记数值区域
- (NSArray *)UUChartMarkRangeInLineCharts:(UUChart *)chart;

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index;
@end


@interface UUChart : UIView

@property (nonatomic,copy) NSArray *yTextArray;//y轴坐标对应的文字
@property (assign, nonatomic) NSInteger lines;//y坐标线条数
@property (assign, nonatomic) NSInteger StepCount;//步进值
@property (nonatomic,copy) NSArray *colorsArray;//点颜色的数据

//是否自动显示范围
@property (nonatomic, assign) BOOL showRange;

@property (nonatomic,copy) NSArray *yValuesArray;//y轴对应的每个点的值，用于设置y轴

@property (assign) UUChartStyle chartStyle;

-(id)initwithUUChartDataFrame:(CGRect)rect withSource:(id<UUChartDataSource>)dataSource withStyle:(UUChartStyle)style;

- (void)showInView:(UIView *)view;

-(void)strokeChart;

//modify
@property (nonatomic,copy)NSMutableArray *topArr;
@property (nonatomic,copy)NSMutableArray *bottomArr;
@property (nonatomic,assign)BOOL isCustomSection;
@property (nonatomic,copy) NSArray *redPointArr;
@property (nonatomic,assign) CGPoint redPoint;
@property (nonatomic,assign) NSInteger nums;//默认0代表身高体重、7周报、30月报
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
