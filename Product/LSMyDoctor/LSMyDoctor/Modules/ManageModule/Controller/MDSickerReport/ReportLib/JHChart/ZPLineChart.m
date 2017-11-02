//
//  ZPLineChart.m
//  JHChartDemo
//
//  Created by MagicBeans2 on 16/12/12.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "ZPLineChart.h"
#define kXandYSpaceForSuperView 20.0
@interface ZPLineChart ()
@property (assign, nonatomic)   CGFloat  xLength;
@property (assign , nonatomic)  CGFloat  yLength;
@property (assign , nonatomic)  CGFloat  perXLen ;
@property (assign , nonatomic)  CGFloat  perYlen ;
@property (assign , nonatomic)  CGFloat  perValue ;
@property (nonatomic,strong)    NSMutableArray * drawDataArr;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (assign , nonatomic) BOOL  isEndAnimation ;
@property (nonatomic,strong) NSMutableArray * layerArr;
@end
@implementation ZPLineChart

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        _lineWidth = 0.5;
        self.contentInsets = UIEdgeInsetsMake(20, 30, 20, 20);
        _yLineDataArr  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xLineDataArr  = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xAndYLineColor = UIColorHex(@"5593E8");
        _pointNumberColorArr = @[[UIColor redColor]];
        _positionLineColorArr = @[UIColorHex(@"5593E8")];
        _pointColorArr = @[UIColorHex(@"FF8056")];
        _xAndYNumberColor = UIColorHex(@"5593E8");
        _valueLineColorArr = @[[UIColor redColor]];
        _layerArr = [NSMutableArray array];
        //        _contentFillColorArr = @[[UIColor lightGrayColor]];
        [self configChartXAndYLength];//获取X与Y轴的长度
        [self configChartOrigin];//构建折线图原点
        [self configPerXAndPerY];//获取每个X或y轴刻度间距
        
    }
    return self;
}
/**
 *  清除图标内容
 */
-(void)clear{
    
    _valueArr = nil;
    _drawDataArr = nil;
    
    for (CALayer *layer in _layerArr) {
        
        [layer removeFromSuperlayer];
    }
    [self showAnimation];
    
}
/**
 *  获取X与Y轴的长度
 */
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}
/**
 *  构建折线图原点
 */
- (void)configChartOrigin{
    
    self.chartOrigin = CGPointMake(self.contentInsets.left+5, self.frame.size.height-self.contentInsets.bottom);
    
}
/**
 *  获取每个X或y轴刻度间距
 */
- (void)configPerXAndPerY{
    
    _perXLen = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
    _perYlen = (_yLength-kXandYSpaceForSuperView);
    
}
/**
 *  重写ValueArr的setter方法 赋值时改变Y轴刻度大小
 *
 */
-(void)setValueArr:(NSArray *)valueArr{
    
    _valueArr = valueArr;
    
    //    [self updateYScale];
    
}
/**
 *  更新Y轴的刻度大小
 */
- (void)updateYScale{
    
    
}
/* 绘制x与y轴 */
- (void)drawXAndYLineWithContext:(CGContextRef)context{
    //14
    //    [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, (self.chartOrigin.y)/2-4) andEndPoint:P_M(self.contentInsets.left+_xLength, (self.chartOrigin.y)/2-4) andIsDottedLine:NO andColor:[UIColor redColor]];
    //    //y
    //    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
    
    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
    [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
    if (_xLineDataArr.count>0) {
        CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
        
        for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
            CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
            CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
            [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
            if (_isMonth) {
                if (i%5==0) {
                    [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
            }else{
                [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
            }
            //modify
            if (i == _xLineDataArr.count-1) {
                [self drawText:[NSString stringWithFormat:@"%@",@"日期"] andContext:context atPoint:P_M(p.x+len-10, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
            }
        }
    }
    
    if (_yLineDataArr.count>0) {
        CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/([[_yLineDataArr lastObject] floatValue]);
        for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
            CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - yPace*[_yLineDataArr[i] floatValue]);
            CGFloat len = [self getTextWithWhenDrawWithText:_yNameDataArr[i]];
            [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawText:[NSString stringWithFormat:@"%@",_yNameDataArr[i]] andContext:context atPoint:P_M(p.x-len-2, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
            
            //modify
            if (i == _yLineDataArr.count-1) {
                [self drawText:[NSString stringWithFormat:@"%@",_yName] andContext:context atPoint:P_M(p.x-len-2, p.y-35) WithColor:_xAndYNumberColor andFontSize:10.0];
                CGFloat len = [[NSString stringWithFormat:@"%@",_orangeNameStr] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
                UILabel *orangeLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-len-10, 10, len, 20)];
                orangeLbl.text=_orangeNameStr;
                orangeLbl.font=[UIFont systemFontOfSize:12];
                orangeLbl.textColor=UIColorHex(@"666666");
                [self addSubview:orangeLbl];
                
                UILabel *orangeLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-len-30, 15, 10, 10)];
                orangeLblColor.text=@"";
                orangeLblColor.layer.cornerRadius=5;
                orangeLblColor.clipsToBounds=YES;
                orangeLblColor.font=[UIFont systemFontOfSize:12];
                orangeLblColor.backgroundColor=UIColorHex(@"FF8056");
                [self addSubview:orangeLblColor];
                
                CGFloat blueLen = [[NSString stringWithFormat:@"%@",_blueNameStr] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
                UILabel *blueLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-len-40-blueLen, 10, blueLen, 20)];
                blueLbl.text=_blueNameStr;
                blueLbl.font=[UIFont systemFontOfSize:12];
                blueLbl.textColor=UIColorHex(@"666666");
                [self addSubview:blueLbl];
                
                UILabel *blueLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-len-60-blueLen, 15, 10, 10)];
                blueLblColor.text=@"";
                blueLblColor.layer.cornerRadius=5;
                blueLblColor.clipsToBounds=YES;
                blueLblColor.font=[UIFont systemFontOfSize:12];
                blueLblColor.backgroundColor=UIColorHex(@"5593E8");
                [self addSubview:blueLblColor];
                //是否隐藏
                orangeLbl.hidden=_isHidden;
                orangeLblColor.hidden=_isHidden;
                blueLbl.hidden=_isHidden;
                blueLblColor.hidden=_isHidden;
                
            }
        }
    }
}
/**
 *  动画展示路径
 */
-(void)showAnimation{
    [self configPerXAndPerY];
    [self configValueDataArray];
    [self drawAnimation];
}


- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawXAndYLineWithContext:context];
    
    
    if (!_isEndAnimation) {
        return;
    }
    
    if (_drawDataArr.count) {
        //        [self drawPositionLineWithContext:context];
    }
    
}
/**
 *  装换值数组为点数组
 */
- (void)configValueDataArray{
    _drawDataArr = [NSMutableArray array];
    
    if (_valueArr.count==0) {
        return;
    }
    
    _perValue = _perYlen/[[_yLineDataArr lastObject] floatValue];
    
    for (NSArray *valueArr in _valueArr) {
        NSMutableArray *dataMArr = [NSMutableArray array];
        for (NSInteger i = 0; i<valueArr.count; i++) {
            
            CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
            NSValue *value = [NSValue valueWithCGPoint:p];
            [dataMArr addObject:value];
        }
        [_drawDataArr addObject:[dataMArr copy]];
        
    }
}
/**
 *  设置点的引导虚线
 *
 *  @param context 图形面板上下文
 */
- (void)drawPositionLineWithContext:(CGContextRef)context{
    
    if (_drawDataArr.count==0) {
        return;
    }
    
    for (NSInteger m = 0;m<_valueArr.count;m++) {
        NSArray *arr = _drawDataArr[m];
        
        for (NSInteger i = 0 ;i<arr.count;i++ ) {
            
            CGPoint p = [arr[i] CGPointValue];
            UIColor *positionLineColor;
            if (_positionLineColorArr.count == _valueArr.count) {
                positionLineColor = _positionLineColorArr[m];
            }else
                positionLineColor = UIColorHex(@"FF8056");
            
            
            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, p.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            [self drawLineWithContext:context andStarPoint:P_M(p.x, self.chartOrigin.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            
            if (p.y!=0) {
                //                UIColor *pointNumberColor = (_pointNumberColorArr.count == _valueArr.count?(_pointNumberColorArr[m]):(UIColorHex(@"FF8056")));
                
                //去提示文字
                if (![[NSString stringWithFormat:@"%@",_valueArr[m][i]] isEqualToString:@""]) {
                    //                            [self drawText:[NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:10.0];
                }
                
            }
            
            
        }
    }
    
    _isEndAnimation = NO;
    
    
}
//执行动画
- (void)drawAnimation{
    
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = [CAShapeLayer layer];
    if (_drawDataArr.count==0) {
        return;
    }
    
    //第一、UIBezierPath绘制线段
    [self configPerXAndPerY];
    
    for (NSInteger i = 0;i<_drawDataArr.count;i++) {
        
        NSArray *dataArr = _drawDataArr[i];
        
        [self drawPathWithDataArr:dataArr andIndex:i];
        
    }
}


- (CGPoint)centerOfFirstPoint:(CGPoint)p1 andSecondPoint:(CGPoint)p2{
    
    
    return P_M((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0);
    
}



- (void)drawPathWithDataArr:(NSArray *)dataArr andIndex:(NSInteger )colorIndex{
    
    UIBezierPath *firstPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
    
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i<dataArr.count; i++) {
        
        NSValue *value = dataArr[i];
        
        CGPoint p = value.CGPointValue;
        
        if (_pathCurve) {
            if (i==0) {
                
                if (_contentFill) {
                    
                    [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                    [secondPath addLineToPoint:p];
                }
                
                [firstPath moveToPoint:p];
            }else{
                CGPoint nextP = [dataArr[i-1] CGPointValue];
                CGPoint control1 = P_M(p.x + (nextP.x - p.x) / 2.0, nextP.y );
                CGPoint control2 = P_M(p.x + (nextP.x - p.x) / 2.0, p.y);
                [secondPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
                [firstPath addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
            }
        }else{
            
            if (i==0) {
                if (_contentFill) {
                    [secondPath moveToPoint:P_M(p.x, self.chartOrigin.y)];
                    [secondPath addLineToPoint:p];
                }
                [firstPath moveToPoint:p];
                //                   [secondPath moveToPoint:p];
            }else{
                //modify
                if([[NSString stringWithFormat:@"%@",_valueArr[colorIndex][i]] isEqualToString:@""]){
                    [firstPath moveToPoint:((NSValue *)dataArr[i+1]).CGPointValue];
                    if (i+2<dataArr.count) {
                        p=((NSValue *)dataArr[i+2]).CGPointValue;
                        continue;
                    }
                }else{
                    if ([_valueArr[colorIndex][i-1] isEqualToString:@""]) {
                        [firstPath moveToPoint:p];
                        [secondPath addLineToPoint:p];
                    }else{
                        [firstPath addLineToPoint:p];
                        [secondPath addLineToPoint:p];
                    }
                }
                
            }
            
        }
        
        if (i==dataArr.count-1) {
            
            [secondPath addLineToPoint:P_M(p.x, self.chartOrigin.y)];
            
        }
    }
    
    
    
    if (_contentFill) {
        [secondPath closePath];
    }
    
    //第二、UIBezierPath和CAShapeLayer关联
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = firstPath.CGPath;
    //线颜色
    UIColor *color = (_valueLineColorArr.count==_drawDataArr.count?(_valueLineColorArr[colorIndex]):(UIColorHex(@"5593E8")));
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = (_animationPathWidth<=0?2:_animationPathWidth);
    
    //第三，动画
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    
    ani.fromValue = @0;
    
    ani.toValue = @1;
    
    ani.duration = 2.0;
    
    ani.delegate = self;
    
    [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.layer addSublayer:shapeLayer];
    [_layerArr addObject:shapeLayer];
    
    weakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ani.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CAShapeLayer *shaperLay = [CAShapeLayer layer];
        shaperLay.frame = weakself.bounds;
        shaperLay.path = secondPath.CGPath;
        if (weakself.contentFillColorArr.count == weakself.drawDataArr.count) {
            
            shaperLay.fillColor = [weakself.contentFillColorArr[colorIndex] CGColor];
        }else{
            shaperLay.fillColor = [UIColor clearColor].CGColor;
        }
        
        [weakself.layer addSublayer:shaperLay];
        [_layerArr addObject:shaperLay];
    });
    
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (flag) {
        
        
        
        [self drawPoint];
        
        
    }
    
}
/**
 *  绘制值的点
 */
- (void)drawPoint{
    
    for (NSInteger m = 0;m<_drawDataArr.count;m++) {
        
        NSArray *arr = _drawDataArr[m];
        for (NSInteger i = 0; i<arr.count; i++) {
            
            NSValue *value = arr[i];
            
            CGPoint p = value.CGPointValue;
            
            
            UIBezierPath *pBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            [pBezier moveToPoint:p];
            //            [pBezier addArcWithCenter:p radius:13 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            //点颜色
            UIColor *color = (UIColorHex(@"5593E8"));
            
            if([[NSString stringWithFormat:@"%@",_valueArr[m][i]] isEqualToString:@""]){
                pLayer.fillColor = [UIColor clearColor].CGColor;
            }else{
                if (_otherPointColorArr.count>0) {
                    for (NSString *other in _otherPointColorArr) {
                        if(i == [other intValue]){
                            pLayer.fillColor = UIColorHex(@"FF8056").CGColor;
                            break;
                        }else{
                            pLayer.fillColor =color.CGColor;
                            
                        }
                        
                    }
                    
                }else{
                    pLayer.fillColor =color.CGColor;
                }
            }
            CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            
            ani.fromValue = @0;
            
            ani.toValue = @1;
            
            ani.duration = 1;
            
            
            [pLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
            
            [self.layer addSublayer:pLayer];
            [_layerArr addObject:pLayer];
            
            
        }
        _isEndAnimation = YES;
        
        [self setNeedsDisplay];
    }
}

@end
