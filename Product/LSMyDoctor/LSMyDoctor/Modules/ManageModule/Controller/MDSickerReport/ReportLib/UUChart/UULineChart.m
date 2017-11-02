//
//  UULineChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UULineChart.h"
#import "UUColor.h"
#import "UUChartLabel.h"
#import "Function.h"

@implementation UULineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setSteps:(NSArray *)Steps{
    _Steps=Steps;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;

    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 5) {
        max = 5;
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    
    BOOL isSameYStep = YES;//Y轴步进值是否相同
    for (int i = 0; i < _yValuesArray.count - 2; ++i) {
        NSInteger value1 = [_yValuesArray[i] integerValue];
        NSInteger value2 = [_yValuesArray[i+1] integerValue];
        NSInteger value3 = [_yValuesArray[i+2] integerValue];
        
        isSameYStep = (value2 - value1)==(value3 - value2)?YES:NO;
    }

//    float level = (_yValueMax-_yValueMin) /(self.lines-1);
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /(self.lines-1);

    for (int i=0; i<self.lines; i++) {
        
        UUChartLabel * label = [[UUChartLabel alloc] init];
        if (isSameYStep) {
            label.frame = CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight);
        }else{
            NSInteger value = [_yValuesArray[i] integerValue];
            label.frame = CGRectMake(0.0,chartCavanHeight - chartCavanHeight*(value/_yValueMax)+5, UUYLabelwidth, UULabelHeight);
            
        }
        
//		label.text = [NSString stringWithFormat:@"%d",(int)(level * i+_yValueMin)];
//        label.backgroundColor=[UIColor redColor];
        label.text = _yTextArray[i];
		[self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        //显示范围颜色
        view.backgroundColor = UUFanweiBgOcolor;//[[UIColor grayColor] colorWithAlphaComponent:0.1];
        if (_isCustomSection) {
            [self testPoint];
        }else{
            [self addSubview:view];
        }
    }
    
    if ([super respondsToSelector:@selector(setCoverValues:)]) {
        for (int y=0; y<_coverValues.count; y++) {
            CGFloat _x=[_coverValues[y][0] floatValue];
            CGFloat _y=[_coverValues[y][1] floatValue];
            
            CGRange markRange={_x,_y};
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (markRange.max-markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
            //显示范围颜色
//            view.backgroundColor = UUFanweiBgOcolor;//[[UIColor grayColor] colorWithAlphaComponent:0.1];
//            if (y%2) {
//                view.backgroundColor = UUFanweiBgTcolor;//[[UIColor redColor] colorWithAlphaComponent:0.1];
//            }
            UIColor *color = [_colors objectAtIndex:y];
            view.backgroundColor = [color colorWithAlphaComponent:0.4];
            
            [self addSubview:view];
        }
    }

    BOOL isNotDrawY = YES;
    //画横线
    for (int i=0; i<self.lines; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            NSInteger value = [_yValuesArray[i] integerValue];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            if (isSameYStep) {
                [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
                [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            }else{
                [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+chartCavanHeight - chartCavanHeight*(value/_yValueMax))];
                [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+chartCavanHeight - chartCavanHeight*(value/_yValueMax))];
                
            }
            
            [path closePath];
            shapeLayer.path = path.CGPath;
            
            
            if (isSameYStep) {
                
                if ([_yValuesArray[i] integerValue] == 0 && i != 0) {
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                    isNotDrawY = NO;
                }else if(i == _yValuesArray.count - 1 && isNotDrawY){
                    
                    
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                    
                }else{
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                }
            }else{
                if ([_yValuesArray[i] integerValue] == 0) {
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                    isNotDrawY = NO;
                }else if(i == _yValuesArray.count - 1 && isNotDrawY){
                    
                    
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                    
                }else{
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                }
            }
            
            
            
//            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];//UUChatcolor.CGColor;//
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
//        num=20.0;
        //modify
        if (_isCustomSection) {
            num=xLabels.count;
        }else{
            num =20.0;
        }
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    
    if (_Steps) {//步进数组时，采用步进数组，特殊处理。
        _xLabelWidth=(self.frame.size.width - UUYLabelwidth)/(num+1);
        NSInteger count=0;
        for (NSString *str in _Steps) {
            count+=[str integerValue];
        }
        CGFloat a=(self.frame.size.width - UUYLabelwidth)/(count);
        CGFloat w=5;
        for (int k=0;k<_Steps.count;k++) {
            w+=a*[_Steps[k] integerValue];
            NSString *labelText = xLabels[k];
            UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(w, self.frame.size.height - UULabelHeight, _xLabelWidth + 20, UULabelHeight)];
            if (_StepCount==1 && k == _Steps.count - 1) {
                //步进值为1且是最后一个label
                label.frame = CGRectMake(w - 5, self.frame.size.height - UULabelHeight, _xLabelWidth + 10, UULabelHeight);
            }
            if (_StepCount==5) {
                //步进值为1
                if (k == _Steps.count - 1) {
                    //是最后一个label
                    label.frame = CGRectMake(w - 4, self.frame.size.height - UULabelHeight, _xLabelWidth + 20, UULabelHeight);
                }else{
                    label.frame = CGRectMake(w + 5, self.frame.size.height - UULabelHeight, _xLabelWidth + 20, UULabelHeight);
                }
                
            }
            label.text = [NSString stringWithFormat:@"  %@",labelText];
            if (labelText.length <= 0) {
                label.backgroundColor = [UIColor clearColor];
            }
            if (kScreenWidth < 375) {
                label.font = [UIFont boldSystemFontOfSize:8.5f];
            }
            label.textAlignment=NSTextAlignmentCenter;
            [self addSubview:label];
        }
    }else{
        _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/(num*self.StepCount-1);
        _xLabelWidth=_xLabelWidth*self.StepCount;
        for (int i=0; i<xLabels.count*self.StepCount; i++) {
            if (i%self.StepCount==0) {
                NSString *labelText = xLabels[i/self.StepCount];
                UUChartLabel * label = [[UUChartLabel alloc] init];

                NSInteger a1 = 10;
                if (labelText.length > 4) {
                    a1 = 15;
                }
                label.frame = CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth - a1, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                
                if (i%self.StepCount==0) {
                    label.text = [NSString stringWithFormat:@"  %@",labelText];
                }
                label.textAlignment=NSTextAlignmentLeft;
                if (i==(xLabels.count*self.StepCount-1)) {
                    if (_StepCount == 1) {
                        if (_isCustomSection) {
                            label.frame=CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth-28, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                        }else{
                            NSInteger a2 = 28;
                            if (labelText.length > 4) {
                                a2 = 32;
                            }
                             label.frame=CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth-a2, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                        }
                    }
                    
                    //                if (self.StepCount==1 && i != xLabels.count*self.StepCount - 1) {
                    //                    label.frame=CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth-25, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                    //                }
                    //                if (_StepCount == 1 && ) {
                    //
                    //                    label.frame = CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth-100, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                    //
                    //                }
                    
                }else if (_StepCount == 5 && i==(xLabels.count-1)*self.StepCount) {
                    label.frame=CGRectMake(i/self.StepCount * _xLabelWidth+UUYLabelwidth-25, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight);
                }
                if (kScreenWidth < 375) {
                    label.font = [UIFont boldSystemFontOfSize:8.5f];
                }
                if (labelText.length <= 0) {
                    label.backgroundColor = [UIColor clearColor];
                }
                [self addSubview:label];
            }
            
        }
    }
        _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/(num*self.StepCount-1);
        //画竖线
        NSInteger count=0;
        for (NSString *str in _Steps) {
            count+=[str integerValue];
        }
        if (_Steps) {//当有数组步进值时，特殊处理
//            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//            UIBezierPath *path = [UIBezierPath bezierPath];
//            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight)];
//            [path addLineToPoint:CGPointMake(UUYLabelwidth,self.frame.size.height-2*UULabelHeight)];
//            [path closePath];
//            shapeLayer.path = path.CGPath;
//            shapeLayer.strokeColor = UUChatcolor.CGColor;
//            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
//            shapeLayer.lineWidth = 1;
//            
//            [self.layer addSublayer:shapeLayer];
            
            CGFloat a=(self.frame.size.width - UUYLabelwidth - 5)/(count);
            CGFloat w=0;
            for (int k=0;k<_Steps.count;k++) {
                w+=a*[_Steps[k] integerValue];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                UIBezierPath *path = [UIBezierPath bezierPath];
//                if (k == _Steps.count - 1) {
//                    [path moveToPoint:CGPointMake(UUYLabelwidth+w - 5,UULabelHeight)];
//                    [path addLineToPoint:CGPointMake(UUYLabelwidth+w - 5,self.frame.size.height-2*UULabelHeight)];
//                }else{
                
                    [path moveToPoint:CGPointMake(UUYLabelwidth+w,UULabelHeight)];
                    [path addLineToPoint:CGPointMake(UUYLabelwidth+w,self.frame.size.height-2*UULabelHeight)];
//                }
                [path closePath];
                shapeLayer.path = path.CGPath;
                
                if (k == 0) {
                    
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                }else{
                    
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                        //shapeLayer.strokeColor = UUChatcolor.CGColor;
                }
                shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
                shapeLayer.lineWidth = 1;
                [self.layer addSublayer:shapeLayer];
            }
        }else{
            for (int i=0; i<xLabels.count*self.StepCount+1; i++) {
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                UIBezierPath *path = [UIBezierPath bezierPath];
                
                if (_StepCount == 1 && i == (xLabels.count - 1)*self.StepCount) {
                    
                    [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth - 5,UULabelHeight)];
                    [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth -5,self.frame.size.height-2*UULabelHeight)];
                }else{
                    
                    [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
                    [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
                }
                
                [path closePath];
                shapeLayer.path = path.CGPath;
                
                if (i == 0) {
                    
                    shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:1.0] CGColor];
                }else{
                    
                    if (i%self.StepCount==0) {
                        
                        //shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                        if (_StepCount == 1 || (_StepCount == 5 && i != (xLabels.count - 1)*self.StepCount)) {
                            
                            shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                        }
                        //shapeLayer.strokeColor = UUChatcolor.CGColor;
                    }else if(self.StepCount == 5 && i == (xLabels.count - 1)*self.StepCount - 1){
                        
                        shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                    }else if(self.StepCount == 5 && i == (xLabels.count - 1)*self.StepCount){
                        
                        shapeLayer.strokeColor = [[[UIColor clearColor] colorWithAlphaComponent:0.2] CGColor];
                    }
                    if (xLabels.count*self.StepCount==i) {
                        
                        shapeLayer.strokeColor = [[BarColor colorWithAlphaComponent:0.2] CGColor];
                        //shapeLayer.strokeColor = UUChatcolor.CGColor;
                    }
                }
                
                
                shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
                shapeLayer.lineWidth = 1;
                [self.layer addSublayer:shapeLayer];
            }
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
#pragma mark - 方法一，多条线时使用，没有动画效果图
    //方法一，多条线时使用，没有动画效果图
    CGPoint temp_point=CGPointMake(0, 0);
    BOOL isNextHavePoint = NO;
    for (int i=0; i<_yValues.count; i++) {
        
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        if (_Steps) {//如果有数组步进值时，特殊处理
            NSInteger count=0;
            for (NSString *str in _Steps) {
                count+=[str integerValue];
            }
            CGFloat a=(self.frame.size.width - UUYLabelwidth - 5)/(count);
            CGFloat w=0;
            
            CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
            CGFloat xPosition = UUYLabelwidth;
            CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
            
            NSInteger index = 0;
            for (NSString * valueString in childAry) {
                
                NSString *colorStr = _colorsArray[index];
                //划线
                CAShapeLayer *_chartLine = [CAShapeLayer layer];
                _chartLine.lineCap = kCALineCapRound;
                _chartLine.lineJoin = kCALineJoinBevel;
                _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
                _chartLine.lineWidth   = 2.0;
                _chartLine.strokeEnd   = 0.0;
                if ([[_colors objectAtIndex:i] CGColor]) {
                    _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
                }else{
                    _chartLine.strokeColor = [UUGreen CGColor];
                }
                [self.layer addSublayer:_chartLine];
                UIBezierPath *progressline = [UIBezierPath bezierPath];
                if (index==0) {
                    float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
                    //第一个点
                    BOOL isShowMaxAndMinPoint = YES;
                    if (self.ShowMaxMinArray) {
                        if ([self.ShowMaxMinArray[i] intValue]>0) {
                            isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
                        }else{
                            isShowMaxAndMinPoint = YES;
                        }
                    }
                    temp_point=CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                    if (valueString.length>0) {
                        [self addPoint:temp_point
                                 index:i
                                isShow:isShowMaxAndMinPoint
                                 value:firstValue colorString:colorStr];
                    }
                    [progressline moveToPoint:temp_point];
                    [progressline setLineWidth:2.0];
                    [progressline setLineCapStyle:kCGLineCapRound];
                    [progressline setLineJoinStyle:kCGLineJoinRound];
                    
                    
                }
                if (index!=0) {
                    float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
                    
                    [progressline moveToPoint:temp_point];
                    [progressline setLineWidth:2.0];
                    [progressline setLineCapStyle:kCGLineCapRound];
                    [progressline setLineJoinStyle:kCGLineJoinRound];
                    
                    w+=(a*[_Steps[index] integerValue]);
                    
                    CGPoint point = CGPointMake(xPosition+w, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                    
//                    if (index == childAry.count - 1) {
//                        point = CGPointMake(xPosition+w - 5, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
//                    }
                    
                    [progressline addLineToPoint:point];
                    BOOL isShowMaxAndMinPoint = YES;
                    if (self.ShowMaxMinArray) {
                        if ([self.ShowMaxMinArray[i] intValue]>0) {
                            isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                        }else{
                            isShowMaxAndMinPoint = YES;
                        }
                    }
                    
                    [progressline moveToPoint:point];
                    if (valueString.length>0) {
                        [self addPoint:point
                                 index:i
                                isShow:isShowMaxAndMinPoint
                                 value:[valueString floatValue] colorString:colorStr];
                    }
                    temp_point=point;
                }
                
                if (isNextHavePoint==NO) {
                    _chartLine.strokeColor = [UIColor clearColor].CGColor;
                    isNextHavePoint=YES;
                }else{
                    isNextHavePoint=NO;
                }
                
                if (valueString.length<=0) {
                    _chartLine.strokeColor = [UIColor clearColor].CGColor;
                    isNextHavePoint=NO;
                }else{
                    isNextHavePoint=YES;
                }
                
                _chartLine.path = progressline.CGPath;
                _chartLine.strokeEnd = 1.0;
                
                index++;
                
            }
        }else{
            CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
            CGFloat xPosition = UUYLabelwidth;
            CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
            
            CGFloat chartCavanWidth = (self.frame.size.width - UUYLabelwidth)/(self.StepCount*childAry.count+1);
            NSLog(@"chartCavanWidth:%f",chartCavanWidth);
            NSInteger index = 0;
            for (int x = 0; x < childAry.count; ++ x) {
                
                NSString * valueString = childAry[x];
                NSString *colorStr = _colorsArray[x];
                
                //划线
                CAShapeLayer *_chartLine = [CAShapeLayer layer];
                _chartLine.lineCap = kCALineCapRound;
                _chartLine.lineJoin = kCALineJoinBevel;
                _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
                _chartLine.lineWidth   = 2.0;
                _chartLine.strokeEnd   = 0.0;
                if ([[_colors objectAtIndex:i] CGColor]) {
                    _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
                }else{
                    _chartLine.strokeColor = [UUGreen CGColor];
                }
                [self.layer addSublayer:_chartLine];
                
                UIBezierPath *progressline = [UIBezierPath bezierPath];
                CGFloat piancha=0.0000001f;
                if (self.StepCount==1) {
                    piancha=1.0f;
                }else if (self.StepCount==2) {
                    piancha=8.0f;
                }else if (self.StepCount==3) {
                    piancha=11.0f;
                }else if (self.StepCount==4) {
                    piancha=12.0f;
                }else if (self.StepCount==5) {
                    piancha=12.0f;
                }else if (self.StepCount==6) {
                    piancha=13.0f;
                }else if (self.StepCount==7) {
                    piancha=13.0f;
                }else if (self.StepCount==8) {
                    piancha=14.0f;
                }else if (self.StepCount==9) {
                    piancha=14.0f;
                }else if (self.StepCount==10) {
                    piancha=14.0f;
                }else{
                    piancha=14.0f;
                }
                if (index==0) {
                    float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
                    //第一个点
                    BOOL isShowMaxAndMinPoint = YES;
                    if (self.ShowMaxMinArray) {
                        if ([self.ShowMaxMinArray[i] intValue]>0) {
                            isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
                        }else{
                            isShowMaxAndMinPoint = YES;
                        }
                    }
                    if (valueString.length > 0) {
                        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                                 index:i
                                isShow:isShowMaxAndMinPoint
                                 value:firstValue colorString:colorStr];
                    }
                    [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
                    [progressline setLineWidth:2.0];
                    [progressline setLineCapStyle:kCGLineCapRound];
                    [progressline setLineJoinStyle:kCGLineJoinRound];
                    temp_point=CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                }
                
                if (index!=0) {
                    float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
                    
                    CGPoint point =CGPointMake(xPosition+chartCavanWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                    [progressline moveToPoint:temp_point];
                    [progressline setLineWidth:2.0];
                    [progressline setLineCapStyle:kCGLineCapRound];
                    [progressline setLineJoinStyle:kCGLineJoinRound];
                    
                    point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                    
                    if ((_StepCount == 1 && index == childAry.count - 1) || _xLabels.count != 7) {
                        
                        //x轴不为7个的时候，也左移5
                        point = CGPointMake(xPosition+index*_xLabelWidth - 5, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                    }
                    
                    [progressline addLineToPoint:point];
                    BOOL isShowMaxAndMinPoint = YES;
                    if (self.ShowMaxMinArray) {
                        if ([self.ShowMaxMinArray[i] intValue]>0) {
                            isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                        }else{
                            isShowMaxAndMinPoint = YES;
                        }
                    }
                    
                    [progressline moveToPoint:point];
                    if (valueString.length>0) {
                        [self addPoint:point
                                 index:i
                                isShow:isShowMaxAndMinPoint
                                 value:[valueString floatValue] colorString:colorStr];
                    }
                    temp_point=point;
                }
                
                if (isNextHavePoint==NO) {
                    _chartLine.strokeColor = [UIColor clearColor].CGColor;
                    isNextHavePoint=YES;
                }else{
                    isNextHavePoint=NO;
                }
                
                if (valueString.length<=0) {
                    _chartLine.strokeColor = [UIColor clearColor].CGColor;
                    isNextHavePoint=NO;
                }else{
                    isNextHavePoint=YES;
                }
                
                _chartLine.path = progressline.CGPath;
                _chartLine.strokeEnd = 1.0;
                
                index+=1;
            }
        }
        
    }
    return;
#pragma mark - 方法二，一条线时使用，并且有动画效果图
    //方法二，一条线时使用，并且有动画效果图
    //    for (int i=0; i<_yValues.count; i++) {
    //        NSArray *childAry = _yValues[i];
    //        if (childAry.count==0) {
    //            return;
    //        }
    //        //获取最大最小位置
    //        CGFloat max = [childAry[0] floatValue];
    //        CGFloat min = [childAry[0] floatValue];
    //        NSInteger max_i;
    //        NSInteger min_i;
    //
    //        for (int j=0; j<childAry.count; j++){
    //            CGFloat num = [childAry[j] floatValue];
    //            if (max<=num){
    //                max = num;
    //                max_i = j;
    //            }
    //            if (min>=num){
    //                min = num;
    //                min_i = j;
    //            }
    //        }
    //
    //        //划线
    //        CAShapeLayer *_chartLine = [CAShapeLayer layer];
    //        _chartLine.lineCap = kCALineCapRound;
    //        _chartLine.lineJoin = kCALineJoinBevel;
    //        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    //        _chartLine.lineWidth   = 2.0;
    //        _chartLine.strokeEnd   = 0.0;
    //        if ([[_colors objectAtIndex:i] CGColor]) {
    //            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
    //        }else{
    //            _chartLine.strokeColor = [UUGreen CGColor];
    //        }
    //
    //        [self.layer addSublayer:_chartLine];
    //
    //        UIBezierPath *progressline = [UIBezierPath bezierPath];
    //        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
    //        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
    //        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    //
    //        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
    //
    //        //第一个点
    //        BOOL isShowMaxAndMinPoint = YES;
    //        if (self.ShowMaxMinArray) {
    //            if ([self.ShowMaxMinArray[i] intValue]>0) {
    //                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
    //            }else{
    //                isShowMaxAndMinPoint = YES;
    //            }
    //        }
    //        [self addPoint:CGPointMake(xPosition-xPosition/2.0f-2, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
    //                 index:i
    //                isShow:isShowMaxAndMinPoint
    //                 value:firstValue];
    //
    //
    //        [progressline moveToPoint:CGPointMake(xPosition-xPosition/2.0f-2, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
    //        [progressline setLineWidth:2.0];
    //        [progressline setLineCapStyle:kCGLineCapRound];
    //        [progressline setLineJoinStyle:kCGLineJoinRound];
    //        NSInteger index = 0;
    //        for (NSString * valueString in childAry) {
    //            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
    //            if (index != 0) {
    //
    //                CGPoint point = CGPointMake(xPosition-xPosition/2.0f-2+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
    //                [progressline addLineToPoint:point];
    //
    //                BOOL isShowMaxAndMinPoint = YES;
    //                if (self.ShowMaxMinArray) {
    //                    if ([self.ShowMaxMinArray[i] intValue]>0) {
    //                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
    //                    }else{
    //                        isShowMaxAndMinPoint = YES;
    //                    }
    //                }
    //                [progressline moveToPoint:point];
    //                [self addPoint:point
    //                         index:i
    //                        isShow:isShowMaxAndMinPoint
    //                         value:[valueString floatValue]];
    //
    ////                [progressline stroke];
    //            }
    //            index += 1;
    //        }
    //        _chartLine.path = progressline.CGPath;
    //
    //        //设置是否动画效果
    //        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //        pathAnimation.duration = childAry.count*0.4;
    //        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    //        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //        pathAnimation.autoreverses = NO;
    //        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    //        
    //        _chartLine.strokeEnd = 1.0;
    //    }
}
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value colorString:(NSString *)colorStr
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
//    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
    if ([colorStr isEqualToString:@"1"]) {
        
        view.layer.borderColor = UULinecolor.CGColor;
        view.backgroundColor = UULinecolor;
    }else if ([colorStr isEqualToString:@"2"]){
        
        view.layer.borderColor = UUYellow.CGColor;
        view.backgroundColor = UUYellow;
    }else if (isHollow) {
        view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
        view.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
    }else{
        view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:UUGreen.CGColor;
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:UUGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:label];
    }
    
    [self addSubview:view];
}

//modify
-(void)testPoint{
    CGFloat chartCavanHeightP = self.frame.size.height - UULabelHeight*3;
    CGFloat total=(_yValueMax-_yValueMin);
    CGFloat per=chartCavanHeightP/total;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width-50,chartCavanHeightP), NO, 0);
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    //    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
    CGContextSetLineWidth(con, 1.0);//线的宽度
    
    //    CGContextMoveToPoint(con, ltPoint.x, ltPoint.y);
    //    CGContextAddLineToPoint(con, rtPoint.x, rtPoint.y);
    //    CGContextAddLineToPoint(con, rbPoint.x, rbPoint.y);
    //    CGContextAddLineToPoint(con, lbPoint.x, lbPoint.y);
    
    
    //Users/MagicBeans2/Downloads/UUChartView/UUChartView/TableViewCell.m/w
    CGFloat w=[UIScreen mainScreen].bounds.size.width-50;
    CGFloat pw=w/(_topArr.count-1);
    for (int i=0; i<_topArr.count; i++) {
        CGPoint currentP=[_topArr[i] CGPointValue];
        
        CGPoint newCP=CGPointMake(currentP.x*pw + 10, (_yValueMax-currentP.y)*per);
        if (i == 0) {
            CGContextMoveToPoint(con, newCP.x, newCP.y);
        }else{
            CGContextAddLineToPoint(con, newCP.x, newCP.y);
        }
    }
    for (int i=0; i<_bottomArr.count; i++) {
        CGPoint currentP=[_bottomArr[i] CGPointValue];
        CGPoint newCP=CGPointMake(currentP.x*pw + 10, (_yValueMax-currentP.y)*per);
        CGContextAddLineToPoint(con, newCP.x, newCP.y);
        
    }
    // 关闭路径(连接起点和最后一个点)
    CGContextClosePath(con);
    CGContextSetFillColorWithColor(con, UIColorHex(@"dae9fa").CGColor);
    
    CGContextFillPath(con);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, [UIScreen mainScreen].bounds.size.width-50 , chartCavanHeightP)];
    [imageView setImage:im];
    imageView.alpha=1;
    [self addSubview:imageView];
    for (NSString *str in _redPointArr) {
        [self testPoint2:CGPointFromString(str) isLast:[str isEqualToString:[_redPointArr lastObject]]];
    }
    
}
//redPoint
-(void)testPoint2:(CGPoint)redPoint isLast:(BOOL) isLast{
    CGFloat chartCavanHeightP = self.frame.size.height - UULabelHeight*3;
    CGFloat total=(_yValueMax-_yValueMin);
    CGFloat per=chartCavanHeightP/total;
    CGFloat w=[UIScreen mainScreen].bounds.size.width-50;
    if (_nums == 30) {
        w=[UIScreen mainScreen].bounds.size.width-50 - 120;//月报
    }else if(_nums == 7){
        w=self.frame.size.width-UUYLabelwidth;//周报
    }
//    CGFloat w=[UIScreen mainScreen].bounds.size.width-50;
    CGFloat pw=w/(_topArr.count-1);//横向格子间距

    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width-50,chartCavanHeightP), NO, 0);
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
//    CGContextAddEllipseInRect(con, CGRectMake(pw*2, (_yValueMax-58000)*per,8,8));
    double width = kScreenWidth;
    if (_nums == 30) {
        //月报
        if (isLast) {
            CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+11, (_yValueMax-redPoint.y)*per - 4,8,8));
        }else{
            if (kScreenHeight > 375) {
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+12, (_yValueMax-redPoint.y)*per - 4,8,8));
            }else if (kScreenHeight < 375) {
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+16, (_yValueMax-redPoint.y)*per - 4,8,8));
            }else{
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+15, (_yValueMax-redPoint.y)*per - 4,8,8));
            }
        }
    }else{
        if (_nums == 7) {
            //周报
            if (isLast) {
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 1, (_yValueMax-redPoint.y)*per - 4,8,8));
            }else{
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 5, (_yValueMax-redPoint.y)*per - 4,8,8));
            }
            
        }else{
            //身高体重头围
            if (kScreenWidth < 375) {
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x  - UUYLabelwidth+15, (_yValueMax-redPoint.y)*per - 4,8,8));
            }else if (kScreenWidth > 375) {
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+7, (_yValueMax-redPoint.y)*per - 4,8,8));
            }else{
                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+11, (_yValueMax-redPoint.y)*per - 4,8,8));
            }
        }
        
//        if (kScreenWidth < 375) {
//            //6sPlus
//            if (_nums == 7) {
//                //周报
//                if (isLast) {
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 1, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }else{
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 5, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }
//                
//            }else{
//                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x  - UUYLabelwidth+15, (_yValueMax-redPoint.y)*per - 4,8,8));
//            }
//            
//        }else if (kScreenWidth > 375) {
//            //6sPlus
//            if (_nums == 7) {
//                //周报
//                if (isLast) {
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 1, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }else{
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 5, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }
//                
//            }else{
//                CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+8.5, (_yValueMax-redPoint.y)*per - 4,8,8));
//            }
//            //CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x - UUYLabelwidth+8.5, (_yValueMax-redPoint.y)*per - 4,8,8));
//        }else{
//            //        NSLog(@"%lf - %lf");
//            if (_nums == 7) {
//                //周报
//                if (isLast) {
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 1, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }else{
//                    CGContextAddEllipseInRect(con, CGRectMake(pw*redPoint.x + 5, (_yValueMax-redPoint.y)*per - 4,8,8));
//                }
//                
//            }else{
//                
//            }
//        }
    }
    
    CGContextSetLineWidth(con, 1.0);//线的宽度

    CGContextSetFillColorWithColor(con, [UIColor redColor].CGColor);
    
    CGContextFillPath(con);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, [UIScreen mainScreen].bounds.size.width-50 , chartCavanHeightP)];
    [imageView setImage:im];
    imageView.alpha=1;
    [self addSubview:imageView];
}

-(void)setTopArr:(NSMutableArray *)topArr{
    _topArr=topArr;
}
-(void)setBottomArr:(NSMutableArray *)bottomArr{
    _bottomArr=bottomArr;
}
-(void)setRedPoint:(CGPoint)redPoint{
    _redPoint=redPoint;
    
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
