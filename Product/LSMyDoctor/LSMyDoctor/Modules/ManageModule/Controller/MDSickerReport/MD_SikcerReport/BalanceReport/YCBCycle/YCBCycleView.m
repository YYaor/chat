//
//  YCBCycleView.m
//  cycle
//
//  Created by yunzujia on 16/11/9.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "YCBCycleView.h"

#import "YCBCusLabel.h"
#import "YCBGetRGB.h"

#define  YScreenW             [UIScreen mainScreen].bounds.size.width
#define  YScreenH             [UIScreen mainScreen].bounds.size.height
#define YCBUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define YCB_TEXT_SIZE(text, font) [text length] > 0 ? [text sizeWithAttributes : @{ NSFontAttributeName : font }] : CGSizeZero;

@implementation YCBCycleView{
    
    CGFloat workStart;//开始弧度
    CGFloat workEnd;//工作消耗量，结果为弧度
    
    CGFloat sportEnd;//运动
    CGFloat sportStart;
    
    CGFloat baseEnd;//基础
    CGFloat baseStart;
    
    UILabel * workCountLab;
    UILabel * baseCountLab;
    UILabel * sportCountLab;
    
    CGPoint cent ;//原点
    CGFloat radius;
    CGFloat lineW;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        cent = CGPointMake(YScreenW / 2.0f, YScreenW / 2.0f - 60);//原点
        radius = YScreenW / 4.5f;//半径
        lineW = 20.0f;//线宽
        workCountLab = [[UILabel alloc] init];
        baseCountLab = [[UILabel alloc] init];
        sportCountLab = [[UILabel alloc] init];
        
        [self addSubview:workCountLab];
        [self addSubview:baseCountLab];
        [self addSubview:sportCountLab];
        
        NSLog(@"init");
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"rect");
    [self setData];
    
    //画弧
    YCBGetRGB * workRgb = [[YCBGetRGB alloc] initWithHexString:@"0X5593e8"];
    [self drawRoundWithRadius:radius andLocation:cent andBorderWidth:lineW andRGB:workRgb Start:workStart End:workEnd];
    
    YCBGetRGB * baseRgb = [[YCBGetRGB alloc] initWithHexString:@"0Xffb434"];
    [self drawRoundWithRadius:radius andLocation:cent andBorderWidth:lineW andRGB:baseRgb Start:baseStart End:baseEnd];
    
    YCBGetRGB * sportRgb = [[YCBGetRGB alloc] initWithHexString:@"0Xfff475"];
    [self drawRoundWithRadius:radius andLocation:cent andBorderWidth:lineW andRGB:sportRgb Start:sportStart End:sportEnd];
    
    
    //中间圆
    CGFloat cRadius = radius / 3.0f;
    CGFloat cBorderW = cRadius * 2;
    YCBGetRGB * cRgb = [[YCBGetRGB alloc] initWithHexString:@"0Xdef9ea"];
    [self drawRoundWithRadius:cRadius andLocation:cent andBorderWidth:cBorderW andRGB:cRgb
                        Start:0 End:2 * M_PI];
    
    //中间圆与外层夹层圆
    CGFloat mRadius = cBorderW + 10;
    CGFloat mBorderW = 15;
    YCBGetRGB * mRgb = [[YCBGetRGB alloc] initWithHexString:@"0Xf0f8ff"];
    [self drawRoundWithRadius:mRadius andLocation:cent andBorderWidth:mBorderW andRGB:mRgb Start:0 End:2 * M_PI ];
    
    
}

/**
 *  数据处理,计算比例
 */
- (void)setData{
    
    CGFloat total = self.workDrain + self.sportDrain + self.baseDrain;
    CGFloat lworkProp = self.workDrain / total;//线占比
    CGFloat lsportProp = self.sportDrain / total;
    CGFloat lbaseProp = self.baseDrain / total;
    
    //计算线弧的起始点和弧度值
    workStart = - 0.5* M_PI;
    workEnd = workStart -  (lworkProp * 2.0) * M_PI;
    
    baseStart = workEnd;
    baseEnd = baseStart - (lbaseProp * 2.0) * M_PI;
    
    sportStart = baseEnd;
    sportEnd = sportStart - (lsportProp * 2.0) * M_PI;
    
    UIFont *labelFont = [UIFont systemFontOfSize:16];
    CGFloat padding = 2;
    CGFloat labelHeight = [labelFont lineHeight] + 5;
    if (!self.unit) {
        self.unit = @"千卡";
    }
    // 设置工作消耗标签
    NSString *wlabelText = [NSString stringWithFormat:@"%.0f%@", self.workDrain,self.unit];
    workCountLab.text = wlabelText;
    //workCountLab.backgroundColor = [UIColor redColor];
    CGPoint pointOnEdge = CGPointMake(cent.x + radius * cos((workEnd + workStart)/2),
                                      cent.y + radius * sin((workEnd + workStart)/2));
    CGSize attributeTextSize = YCB_TEXT_SIZE(wlabelText, labelFont);
    NSInteger wlabelwidth = attributeTextSize.width + 10;
    CGFloat xOffset = pointOnEdge.x >= cent.x ? wlabelwidth / 2.0 + padding : -wlabelwidth / 2.0 - padding;
    CGFloat yOffset = pointOnEdge.y >= cent.y ? labelHeight / 2.0 + padding : -labelHeight / 2.0 - padding;
    CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
    
    if (self.workDrain == 0) {
        
    }else{
        [workCountLab setFrame:CGRectMake(legendCenter.x - wlabelwidth /2, legendCenter.y - labelHeight/2, wlabelwidth, labelHeight)];
        workCountLab.center = legendCenter;
    }
    
    
    // 设置运动消耗标签
    NSString *slabelText = [NSString stringWithFormat:@"%.0f%@", self.sportDrain,self.unit];
    sportCountLab.text = slabelText;
    pointOnEdge = CGPointMake(cent.x + radius * cos((sportEnd + sportStart)/2),
                              cent.y + radius * sin((sportEnd + sportStart)/2));
    attributeTextSize = YCB_TEXT_SIZE(slabelText, labelFont);
    NSInteger slabelwidth = attributeTextSize.width + 10;
    xOffset = pointOnEdge.x >= cent.x ? slabelwidth / 2.0 + padding : -slabelwidth / 2.0 - padding;
    yOffset = pointOnEdge.y >= cent.y ? labelHeight / 2.0 + padding : -labelHeight / 2.0 - padding;
    legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
    if (self.sportDrain == 0) {
        
    }else{
        [sportCountLab setFrame:CGRectMake(legendCenter.x - slabelwidth /2, legendCenter.y - labelHeight/2, slabelwidth, labelHeight)];
        sportCountLab.center = legendCenter;

    }
    
    // 设置基础消耗标签
    
    NSString *blabelText = [NSString stringWithFormat:@"%.0f%@", self.baseDrain,self.unit];
    baseCountLab.text = blabelText;
    pointOnEdge = CGPointMake(cent.x + radius * cos((baseEnd + baseStart)/2),
                              cent.y + radius * sin((baseEnd + baseStart)/2));
    attributeTextSize = YCB_TEXT_SIZE(blabelText, labelFont);
    NSInteger blabelwidth = attributeTextSize.width + 10;
    xOffset = pointOnEdge.x >= cent.x ? blabelwidth / 2.0 + padding : -blabelwidth / 2.0 - padding;
    yOffset = pointOnEdge.y >= cent.y ? labelHeight / 2.0 + padding : -labelHeight / 2.0 - padding;
    legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
    if (self.baseDrain == 0) {
        
    }else{
        [baseCountLab setFrame:CGRectMake(legendCenter.x - blabelwidth /2, legendCenter.y - labelHeight/2, blabelwidth, labelHeight)];
        baseCountLab.center = legendCenter;

    }
    
    //设置对照表
    self.lab1 = [[YCBCusLabel alloc] initWithFrame:CGRectMake(10, cent.y + radius + 40, (kScreenWidth - 30)/2, 30)];
//    self.lab1.backgroundColor = [UIColor redColor];
//    self.lab1.lab2.backgroundColor = [UIColor yellowColor];
    self.lab1.lab1.backgroundColor = YCBUIColorFromRGB(0xffb434);
    
    if (self.thirdTitleStr) {
        //如果圆环标题存在
        self.lab1.lab2.text = self.thirdTitleStr;
    }else{
        //饮食
        self.lab1.lab2.text = @"基础消耗";
    }
    [self addSubview:self.lab1];
    
    
    YCBCusLabel * lab2 = [[YCBCusLabel alloc] initWithFrame:CGRectMake(10 + (kScreenWidth - 30)/2 + 10, cent.y + radius + 40, (kScreenWidth - 30)/2, 30)];
//    lab2.backgroundColor = [UIColor greenColor];
//    lab2.center = CGPointMake(cent.x, lab2.center.y);
    lab2.lab1.backgroundColor = YCBUIColorFromRGB(0xfff475);
    if (self.secondTitleStr) {
        lab2.lab2.text = self.secondTitleStr;
    }else{
        lab2.lab2.text = @"运动消耗";
    }
    [self addSubview:lab2];
    
    YCBCusLabel * lab3 = [[YCBCusLabel alloc] initWithFrame:CGRectMake(10, cent.y + radius + 40 + 40, (kScreenWidth - 30)/2, 30)];
    lab3.lab1.backgroundColor = YCBUIColorFromRGB(0x5593e8);
    if (self.firstTitleStr) {
        lab3.lab2.text = self.firstTitleStr;
    }else{
        lab3.lab2.text = @"工作消耗";
    }
//    lab3.lab2.text = @"工作消耗";
    [self addSubview:lab3];
    
    NSLog(@"loaddata");

}

- (void)layoutSubviews{
    
}

/**
 *  画圆环
 *
 *  @param radius      半径
 *  @param point       原点
 *  @param borderWidth 线宽
 *  @param ycbrgb      色值
 *  @param start       起始点
 *  @param radin       弧度范围
 */
- (void)drawRoundWithRadius:(CGFloat)radiuss andLocation:(CGPoint)point andBorderWidth:(CGFloat)borderWidth andRGB:(YCBGetRGB *)ycbrgb Start:(CGFloat)start  End:(CGFloat) end{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, ycbrgb.corlorR/255.0, ycbrgb.corlorG/255.0, ycbrgb.corlorB/255.0, 1);
    CGContextSetLineWidth(context, borderWidth);
    CGContextAddArc(context, point.x, point.y, radiuss, start, end, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
}
@end
