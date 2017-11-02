//
//  ZPLineChart.h
//  JHChartDemo
//
//  Created by MagicBeans2 on 16/12/12.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"

@interface ZPLineChart : JHChart
@property (nonatomic,strong) NSArray * xLineDataArr;
@property (nonatomic,strong) NSArray * yLineDataArr;
@property (nonatomic,strong) NSArray * yNameDataArr;
@property (nonatomic,strong) NSArray * valueArr;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) NSArray * otherPointColorArr;
@property (nonatomic,copy) NSString *yName;
@property (nonatomic,assign) BOOL isHidden;
@property (nonatomic,assign) BOOL isMonth;
@property (nonatomic,copy) NSString *orangeNameStr;
@property (nonatomic,copy) NSString *blueNameStr;

/**
 *  To draw the line color of the target
 */
@property (nonatomic, strong) NSArray * valueLineColorArr;


/**
 *  X, Y axis line color
 */
@property (nonatomic, strong) UIColor * xAndYLineColor;


/**
 *  Color for each value draw point
 */
@property (nonatomic, strong) NSArray * pointColorArr;


/**
 *  Y, X axis scale numerical color
 */
@property (nonatomic, strong) UIColor * xAndYNumberColor;


/**
 *  Draw dotted line color
 */
@property (nonatomic, strong) NSArray * positionLineColorArr;



/**
 *  Draw the text color of the information.
 */
@property (nonatomic, strong) NSArray * pointNumberColorArr;



/**
 *  Value path is required to draw points
 */
@property (assign,  nonatomic) BOOL hasPoint;



/**
 *  Draw path line width
 */
@property (nonatomic, assign) CGFloat animationPathWidth;


/**
 *  Drawing path is the curve, the default NO
 */
@property (nonatomic, assign) BOOL pathCurve;


/**
 *  Whether to fill the contents of the drawing path, the default NO
 */
@property (nonatomic, assign) BOOL contentFill;


/**
 *  Draw path fill color, default is grey
 */
@property (nonatomic, strong) NSArray * contentFillColorArr;



/**
 *  Custom initialization method
 *
 *  @param frame         frame
 *  @param lineChartType Abandoned
 *
 */
-(instancetype)initWithFrame:(CGRect)frame;



@end
