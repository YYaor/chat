//
//  GYRRadarChart.h
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadarMapLegendTappedHandler <NSObject>

- (void) radarMapLegendTappedHandler : (NSString*) legendString;

@end

@interface GYRRadarChart : UIView

@property (nonatomic, assign) CGFloat r;			//半径
@property (nonatomic, assign) CGFloat maxValue;		//最小值
@property (nonatomic, assign) CGFloat minValue;		//最大值
@property (nonatomic, assign) BOOL drawPoints;		//是否画点
@property (nonatomic, assign) BOOL fillArea;		//是否填充点之间的面积
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) BOOL showStepText;	//是否显示每一圈的值
@property (nonatomic, assign) BOOL showMarkLabel;	//是否显示每一项的分数值
@property (nonatomic, assign) CGFloat colorOpacity;

@property (nonatomic, strong) NSArray *dataSeries;	//雷达图数据
@property (nonatomic, strong) NSArray *attributes;	//雷达图标注，应和雷达图数据一一对应

@property (nonatomic, strong) NSArray * coutArrs; //雷达图下方的数字。应和雷达图attributes一一对应

@property (nonatomic, assign) CGPoint centerPoint;	//中心点
@property (nonatomic, assign) BOOL  clockwise; 		//direction of data

@property (weak  , nonatomic) id<RadarMapLegendTappedHandler> delegate;
//2代表生活日记简单版跳转
@property (nonatomic,copy  ) NSString  	*qnCodeStr;

- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;

@end
