//
//  UULineChart.h
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UUColor.h"

#define chartMargin     10
#define xLabelMargin    15
#define yLabelMargin    15
#define UULabelHeight    10
#define UUYLabelwidth     40
#define UUTagLabelwidth     80

@interface UULineChart : UIView

@property (strong, nonatomic) NSArray * Steps;

@property (strong, nonatomic) NSArray * xLabels;

@property (strong, nonatomic) NSArray * yLabels;
@property (nonatomic,copy) NSArray *yTextArray;//y轴对应坐标的显示文字
@property (nonatomic,copy) NSArray *yValuesArray;//y轴对应的每个点的值，用于设置y轴
@property (nonatomic,copy) NSArray *colorsArray;//点颜色的数据

@property (strong, nonatomic) NSArray * yValues;

@property (nonatomic, strong) NSArray * colors;

@property (strong, nonatomic) NSArray * coverValues;

@property (assign, nonatomic) NSInteger lines;//y坐标线条数
@property (assign, nonatomic) NSInteger StepCount;//步进值

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) CGFloat yValueMax;

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;

@property (nonatomic, assign) BOOL showRange;

@property (nonatomic, retain) NSMutableArray *ShowHorizonLine;
@property (nonatomic, retain) NSMutableArray *ShowMaxMinArray;

-(void)strokeChart;

//modify
@property (nonatomic,retain) NSMutableArray *topArr;
@property (nonatomic,retain) NSMutableArray *bottomArr;
@property (nonatomic,assign) BOOL isCustomSection;
@property (nonatomic,copy) NSArray *redPointArr;
@property (nonatomic,assign) CGPoint redPoint;
@property (nonatomic,assign) NSInteger nums;//默认0代表身高体重、7周报、30月报
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
