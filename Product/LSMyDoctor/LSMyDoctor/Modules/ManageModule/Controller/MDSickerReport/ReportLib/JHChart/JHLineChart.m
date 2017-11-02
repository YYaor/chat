//
//  JHLineChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHLineChart.h"
#define kXandYSpaceForSuperView 20.0

@interface JHLineChart ()

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

@implementation JHLineChart



/**
 *  重写初始化方法
 *
 *  @param frame         frame
 *  @param lineChartType 折线图类型
 *
 *  @return 自定义折线图
 */
-(instancetype)initWithFrame:(CGRect)frame andLineChartType:(JHLineChartType)lineChartType{
    
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.2 alpha:0.3];
        self.backgroundColor=[UIColor whiteColor];
        _lineType = lineChartType;
        _lineWidth = 0.5;
        self.contentInsets = UIEdgeInsetsMake(10, 35, 20, 20);
        _yLineDataArr  = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xLineDataArr  = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        _xAndYLineColor = [UIColor darkGrayColor];
        _pointNumberColorArr = @[[UIColor clearColor]];
        _positionLineColorArr = @[[UIColor darkGrayColor]];
        _pointColorArr = @[[UIColor orangeColor]];
        _xAndYNumberColor = [UIColor darkGrayColor];
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
 *  获取每个X或y轴刻度间距
 */
- (void)configPerXAndPerY{
    
   
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:
        {
            _perXLen = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
            _perYlen = (_yLength-kXandYSpaceForSuperView)/_yLineDataArr.count;
        }
            break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
        {
            _perXLen = (_xLength/2-kXandYSpaceForSuperView)/[(NSArray*)_xLineDataArr[0] count];
            _perYlen = (_yLength-kXandYSpaceForSuperView)/_yLineDataArr.count;
        }
            break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
        {
            _perXLen = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
            _perYlen = (_yLength/2-kXandYSpaceForSuperView)/[(NSArray*)_yLineDataArr[0] count];
        }
            break;
        case JHLineChartQuadrantTypeAllQuardrant:
        {
             _perXLen = (_xLength/2-kXandYSpaceForSuperView)/([(NSArray*)_xLineDataArr[0] count]);
             _perYlen = (_yLength/2-kXandYSpaceForSuperView)/[(NSArray*)_yLineDataArr[0] count];
        }
            break;
            
        default:
            break;
    }
    
}


/**
 *  重写LineChartQuardrantType的setter方法 动态改变折线图原点
 *
 */
-(void)setLineChartQuadrantType:(JHLineChartQuadrantType)lineChartQuadrantType{
    
    _lineChartQuadrantType = lineChartQuadrantType;
    [self configChartOrigin];
    
}



/**
 *  获取X与Y轴的长度
 */
- (void)configChartXAndYLength{
    _xLength = CGRectGetWidth(self.frame)-self.contentInsets.left-self.contentInsets.right;
    _yLength = CGRectGetHeight(self.frame)-self.contentInsets.top-self.contentInsets.bottom;
}


/**
 *  重写ValueArr的setter方法 赋值时改变Y轴刻度大小
 *
 */
-(void)setValueArr:(NSArray *)valueArr{
    
    _valueArr = valueArr;
    
    [self updateYScale];
    
    
}


/**
 *  更新Y轴的刻度大小
 */
- (void)updateYScale{
        switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            
            NSInteger max = 2;
            NSInteger min = 0;
            
            for (NSArray *arr in _valueArr) {
                for (NSString * numer  in arr) {
                    NSInteger i = [numer integerValue];
                    if (i>=max) {
                        max = i;
                    }
                    if (i<=min) {
                        min = i;
                    }
                }
                
            }


            
            
         min = labs(min);
         max = (min<max?(max):(min));
        if (max%5==0) {
                max = max;
            }else
//                max = (max/5+1)*5;
                 max = max;
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *minArr = [NSMutableArray array];
        if (max<=5) {
            for (NSInteger i = 0; i<max; i++) {
                    
                [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*1]];
                }
            }
            
        if (max<=10&&max>5) {
                
                
            for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*2]];

                }
                
            }else if(max>10){
                
                for (NSInteger i = 0; i<max/5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*5]];
                }
                
            }
        
            
            _yLineDataArr = @[[arr copy],[minArr copy]];
            
            
            [self setNeedsDisplay];
            
            
        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            
            NSInteger max = 0;
            NSInteger min = 0;
            
            
            for (NSArray *arr in _valueArr) {
                for (NSString * numer  in arr) {
                    NSInteger i = [numer integerValue];
                    if (i>=max) {
                        max = i;
                    }
                    if (i<=min) {
                        min = i;
                    }
                }
                
            }

            
            min = labs(min);
            max = (min<max?(max):(min));
            if (max%5==0) {
                max = max;
            }else
                max = (max/5+1)*5;
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *minArr = [NSMutableArray array];
            if (max<=5) {
                for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*1]];
                }
            }
            
            if (max<=10&&max>5) {
                
                
                for (NSInteger i = 0; i<5; i++) {
                    
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*2]];
                    
                }
                
            }else if(max>10){
                
                for (NSInteger i = 0; i<max/5; i++) {
                    [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*5]];
                    [minArr addObject:[NSString stringWithFormat:@"-%ld",(i+1)*5]];
                }
                
            }
            _yLineDataArr = @[[arr copy],[minArr copy]];
            
            [self setNeedsDisplay];
        }break;
        default:{
            if (_valueArr.count) {
                
                NSInteger max=0;
                
                for (NSArray *arr in _valueArr) {
                    for (NSString * numer  in arr) {
                        NSInteger i = [numer integerValue];
                        if (i>=max) {
                            max = i;
                        }
                        
                    }
                    
                }

                max=10;
//                if (max%5==0) {
//                    max = max;
//                }else
//                    max = (max/5+1)*2;
//                _yLineDataArr = nil;
                NSMutableArray *arr = [NSMutableArray array];
//                if (max<=5) {
//                    for (NSInteger i = 0; i<5; i++) {
//                        
//                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*1]];
//                        
//                    }
//                }
                
//                if (max<=10&&max>5) {
//                    
//                    
//                    for (NSInteger i = 0; i<5; i++) {
//                        
//                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
//                        
//                    }
//                    
//                }else if(max>10){
                
                    for (NSInteger i = 0; i<max/2; i++) {
                        [arr addObject:[NSString stringWithFormat:@"%ld",(i+1)*2]];
                        
                        
                    }
                    
//                }
                
//                _yLineDataArr = [arr copy];
                
                [self setNeedsDisplay];
                
                
            }

        }
            break;
    }
    
    
    
}


/**
 *  构建折线图原点
 */
- (void)configChartOrigin{
    
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left, self.frame.size.height-self.contentInsets.bottom);
        }
            break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left+_xLength/2, CGRectGetHeight(self.frame)-self.contentInsets.bottom);
        }
            break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
        {
            self.chartOrigin = CGPointMake(self.contentInsets.left, self.contentInsets.top+_yLength/2);
        }
            break;
        case JHLineChartQuadrantTypeAllQuardrant:
        {
             self.chartOrigin = CGPointMake(self.contentInsets.left+_xLength/2, self.contentInsets.top+_yLength/2);
        }
            break;
            
        default:
            break;
    }
    
}




/* 绘制x与y轴 */
- (void)drawXAndYLineWithContext:(CGContextRef)context{
    
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:{
            
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
            if (_xLineDataArr.count>0) {
                CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
                
                for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                    //modify
                    if (i == _xLineDataArr.count-1) {
                        [self drawText:[NSString stringWithFormat:@"%@",@"日期"] andContext:context atPoint:P_M(p.x+len, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                    }
                }
            }
            
            if (_yLineDataArr.count>0) {
                CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
                for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:_yLineDataArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                    
                    //modify
                    if (i == _yLineDataArr.count-1) {
                        [self drawText:[NSString stringWithFormat:@"%@",@"次数"] andContext:context atPoint:P_M(p.x-len-5, p.y-15) WithColor:_xAndYNumberColor andFontSize:10.0];
                        UILabel *orangeLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 20, 40, 20)];
                        orangeLbl.text=@"不正常";
                        orangeLbl.font=[UIFont systemFontOfSize:12];
                        orangeLbl.textColor=[UIColor lightGrayColor];
                        [self addSubview:orangeLbl];
                        
                        UILabel *orangeLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 25, 10, 10)];
                        orangeLblColor.text=@"";
                        orangeLblColor.layer.cornerRadius=5;
                        orangeLblColor.clipsToBounds=YES;
                        orangeLblColor.font=[UIFont systemFontOfSize:12];
                        orangeLblColor.backgroundColor=[UIColor orangeColor];
                        [self addSubview:orangeLblColor];
                        
                        UILabel *blueLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 20, 40, 20)];
                        blueLbl.text=@"正常";
                        blueLbl.font=[UIFont systemFontOfSize:12];
                        blueLbl.textColor=[UIColor lightGrayColor];
                        [self addSubview:blueLbl];
                        
                        UILabel *blueLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-170, 25, 10, 10)];
                        blueLblColor.text=@"";
                        blueLblColor.layer.cornerRadius=5;
                        blueLblColor.clipsToBounds=YES;
                        blueLblColor.font=[UIFont systemFontOfSize:12];
                        blueLblColor.backgroundColor=[UIColor blueColor];
                        [self addSubview:blueLblColor];

                    }
                }
            }
            
        }break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:{
            [self drawLineWithContext:context andStarPoint:P_M(self.contentInsets.left, self.chartOrigin.y) andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength) andIsDottedLine:NO andColor:_xAndYLineColor];
            
            
            if (_xLineDataArr.count == 2) {
                NSArray * rightArr = _xLineDataArr[1];
                NSArray * leftArr = _xLineDataArr[0];
                
                CGFloat xPace = (_xLength/2-kXandYSpaceForSuperView)/(rightArr.count-1);
                
                for (NSInteger i = 0; i<rightArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:rightArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    [self drawText:[NSString stringWithFormat:@"%@",rightArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
                for (NSInteger i = 0; i<leftArr.count;i++ ) {
                    CGPoint p = P_M(self.chartOrigin.x-(i+1)*xPace, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:leftArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    [self drawText:[NSString stringWithFormat:@"%@",leftArr[leftArr.count-1-i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
                
            }
            if (_yLineDataArr.count>0) {
                CGFloat yPace = (_yLength - kXandYSpaceForSuperView)/(_yLineDataArr.count);
                for (NSInteger i = 0; i<_yLineDataArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:_yLineDataArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",_yLineDataArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
            }

        }break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            [self drawLineWithContext:context andStarPoint:self.chartOrigin andEndPoint:P_M(self.contentInsets.left+_xLength, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawLineWithContext:context andStarPoint:P_M(self.contentInsets.left,CGRectGetHeight(self.frame)-self.contentInsets.bottom) andEndPoint:P_M(self.chartOrigin.x,self.contentInsets.top+12) andIsDottedLine:NO andColor:_xAndYLineColor];
            if (_xLineDataArr.count>0) {
                CGFloat xPace = (_xLength-kXandYSpaceForSuperView)/(_xLineDataArr.count-1);
                
                for (NSInteger i = 0; i<_xLineDataArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:_xLineDataArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    if (i==0) {
                        len = -2;
                    }
                    
                    [self drawText:[NSString stringWithFormat:@"%@",_xLineDataArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2+_yLength/2) WithColor:_xAndYNumberColor andFontSize:10.0];
                    if (i ==_xLineDataArr.count-1) {
                        [self drawText:[NSString stringWithFormat:@"%@",@"日期"] andContext:context atPoint:P_M(p.x-len/2+25, p.y+2+_yLength/2) WithColor:_xAndYNumberColor andFontSize:10.0];
                    }
                }
            }
            
            if (_yLineDataArr.count == 2) {
                
                NSArray * topArr = _yLineDataArr[0];
                NSArray * bottomArr = _yLineDataArr[1];
                CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([(NSArray*)_yLineDataArr[0] count]);
                _perYlen = yPace;
                for (NSInteger i = 0; i<topArr.count; i++) {
                    NSString *name=@"";
                    if (i==0) {
                        name=_yNameArr[i+1];
                        //睡眠质量
                        CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y);
                        CGFloat len = [self getTextWithWhenDrawWithText:_yName];
                        [self drawText:[NSString stringWithFormat:@"%@",_yName] andContext:context atPoint:P_M(p.x-len/2-3, p.y-3-_yLength/2) WithColor:_xAndYNumberColor andFontSize:10.0];
                    }else{
                        name=_yNameArr[i-1];
                    }
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:name];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",name] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                    
                }
                
                
                for (NSInteger i = 0; i<bottomArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y + (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:_yNameArr[i+topArr.count+1]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",_yNameArr[i+topArr.count+1]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                    
                }
                //modify
                CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y);
                CGFloat len = [self getTextWithWhenDrawWithText:_yNameArr[2]];
                [self drawText:[NSString stringWithFormat:@"%@",_yNameArr[2]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                
            }

        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x-_xLength/2, self.chartOrigin.y) andEndPoint:P_M(self.chartOrigin.x+_xLength/2, self.chartOrigin.y) andIsDottedLine:NO andColor:_xAndYLineColor];
            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x,self.chartOrigin.y+_yLength/2) andEndPoint:P_M(self.chartOrigin.x,self.chartOrigin.y-_yLength/2) andIsDottedLine:NO andColor:_xAndYLineColor];
            
            
            if (_xLineDataArr.count == 2) {
                NSArray * rightArr = _xLineDataArr[1];
                NSArray * leftArr = _xLineDataArr[0];
                
                CGFloat xPace = (_xLength/2-kXandYSpaceForSuperView)/(rightArr.count-1);
                
                for (NSInteger i = 0; i<rightArr.count;i++ ) {
                    CGPoint p = P_M(i*xPace+self.chartOrigin.x, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:rightArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    [self drawText:[NSString stringWithFormat:@"%@",rightArr[i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
                for (NSInteger i = 0; i<leftArr.count;i++ ) {
                    CGPoint p = P_M(self.chartOrigin.x-(i+1)*xPace, self.chartOrigin.y);
                    CGFloat len = [self getTextWithWhenDrawWithText:leftArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x, p.y-3) andIsDottedLine:NO andColor:_xAndYLineColor];
                    
                    [self drawText:[NSString stringWithFormat:@"%@",leftArr[leftArr.count-1-i]] andContext:context atPoint:P_M(p.x-len/2, p.y+2) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
                
            }

            
            if (_yLineDataArr.count == 2) {
                
                NSArray * topArr = _yLineDataArr[0];
                NSArray * bottomArr = _yLineDataArr[1];
                CGFloat yPace = (_yLength/2 - kXandYSpaceForSuperView)/([(NSArray*)_yLineDataArr[0] count]);
                _perYlen = yPace;
                for (NSInteger i = 0; i<topArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y - (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:topArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",topArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                    
                }
                
                
                for (NSInteger i = 0; i<bottomArr.count; i++) {
                    CGPoint p = P_M(self.chartOrigin.x, self.chartOrigin.y + (i+1)*yPace);
                    CGFloat len = [self getTextWithWhenDrawWithText:bottomArr[i]];
                    [self drawLineWithContext:context andStarPoint:p andEndPoint:P_M(p.x+3, p.y) andIsDottedLine:NO andColor:_xAndYLineColor];
                    [self drawText:[NSString stringWithFormat:@"%@",bottomArr[i]] andContext:context atPoint:P_M(p.x-len-3, p.y-3) WithColor:_xAndYNumberColor andFontSize:10.0];
                }
                
                
            }
            
        }break;
            
        default:
            break;
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
        [self drawPositionLineWithContext:context];
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
    
    switch (_lineChartQuadrantType) {
        case JHLineChartQuadrantTypeFirstQuardrant:{
            _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
            
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
                for (NSInteger i = 0; i<valueArr.count; i++) {
                    
                    CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
                    NSValue *value = [NSValue valueWithCGPoint:p];
                    [dataMArr addObject:value];
                }
                [_drawDataArr addObject:[dataMArr copy]];
                
            }

            
        }break;
        case JHLineChartQuadrantTypeFirstAndSecondQuardrant:{
            
            _perValue = _perYlen/[[_yLineDataArr firstObject] floatValue];
            
            
            
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
              
                    
                    CGPoint p ;
                    for (NSInteger i = 0; i<[(NSArray*)_xLineDataArr[0] count]; i++) {
                        p = P_M(self.contentInsets.left + kXandYSpaceForSuperView+i*_perXLen, self.contentInsets.top + _yLength - [valueArr[i] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                    }
                    
                    for (NSInteger i = 0; i<[(NSArray*)_xLineDataArr[1] count]; i++) {
                        p = P_M(self.chartOrigin.x+i*_perXLen, self.contentInsets.top + _yLength - [valueArr[i+[(NSArray*)_xLineDataArr[0] count]] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                        
                    }
                    
                    
               
                [_drawDataArr addObject:[dataMArr copy]];
                
            }


            
            
        }break;
        case JHLineChartQuadrantTypeFirstAndFouthQuardrant:{
            _perValue = _perYlen/[[_yLineDataArr[0] firstObject] floatValue];
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
                for (NSInteger i = 0; i<valueArr.count; i++) {
                    
                    CGPoint p = P_M(i*_perXLen+self.chartOrigin.x,self.chartOrigin.y - [valueArr[i] floatValue]*_perValue);
                    NSValue *value = [NSValue valueWithCGPoint:p];
                    [dataMArr addObject:value];
                }
                [_drawDataArr addObject:[dataMArr copy]];
                //modify
                [self updateYScale];
            }
            
        }break;
        case JHLineChartQuadrantTypeAllQuardrant:{
            
            
            
            _perValue = _perYlen/[[_yLineDataArr[0] firstObject] floatValue];
            for (NSArray *valueArr in _valueArr) {
                NSMutableArray *dataMArr = [NSMutableArray array];
             
                    
                    CGPoint p ;
                    for (NSInteger i = 0; i<[(NSArray*)_xLineDataArr[0] count]; i++) {
                        p = P_M(self.contentInsets.left + kXandYSpaceForSuperView+i*_perXLen, self.chartOrigin.y-[valueArr[i] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                    }
                    
                    for (NSInteger i = 0; i<[(NSArray*)_xLineDataArr[1] count]; i++) {
                        p = P_M(self.chartOrigin.x+i*_perXLen, self.chartOrigin.y-[valueArr[i+[(NSArray*)_xLineDataArr[0] count]] floatValue]*_perValue);
                        [dataMArr addObject:[NSValue valueWithCGPoint:p]];
                        
                    }
                    
                    
           
                [_drawDataArr addObject:[dataMArr copy]];
                
            }

        }break;
        default:
            break;
    }



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
                      [firstPath moveToPoint:p];
                      [secondPath addLineToPoint:p];
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
                positionLineColor = [UIColor clearColor];

            
            [self drawLineWithContext:context andStarPoint:P_M(self.chartOrigin.x, p.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            [self drawLineWithContext:context andStarPoint:P_M(p.x, self.chartOrigin.y) andEndPoint:p andIsDottedLine:YES andColor:positionLineColor];
            
            if (p.y!=0) {
                UIColor *pointNumberColor = (_pointNumberColorArr.count == _valueArr.count?(_pointNumberColorArr[m]):([UIColor orangeColor]));
                
                switch (_lineChartQuadrantType) {
                       
                        
                    case JHLineChartQuadrantTypeFirstQuardrant:
                    {
                        //去提示文字
                        if (![[NSString stringWithFormat:@"%@",_valueArr[m][i]] isEqualToString:@""]) {
                           [self drawText:[NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i],_valueArr[m][i]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:10.0];
                        }
                        
                    }
                        break;
                    case JHLineChartQuadrantTypeFirstAndSecondQuardrant:
                    {
                        NSString *str = (i<[(NSArray*)_xLineDataArr[0] count]?(_xLineDataArr[0][i]):(_xLineDataArr[1][i-[(NSArray*)_xLineDataArr[0] count]]));
                        [self drawText:[NSString stringWithFormat:@"(%@,%@)",str,_valueArr[m][i]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:10.0];
                    }
                        break;
                    case JHLineChartQuadrantTypeFirstAndFouthQuardrant:
                    {
                        
                        [self drawText:[NSString stringWithFormat:@"(%@,%@)",_xLineDataArr[i/5],_valueArr[m][i/5]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:10.0];
                    }
                        break;
                    case JHLineChartQuadrantTypeAllQuardrant:
                    {
                        NSString *str = (i<[(NSArray*)_xLineDataArr[0] count]?(_xLineDataArr[0][i]):(_xLineDataArr[1][i-[(NSArray*)_xLineDataArr[0] count]]));
                        [self drawText:[NSString stringWithFormat:@"(%@,%@)",str,_valueArr[m][i]] andContext:context atPoint:p WithColor:pointNumberColor andFontSize:10.0];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            
        }
    }
    
     _isEndAnimation = NO;
    
    
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
//            if ([_valueArr[m] isEqualToString:@""]) {
//                break;
//            }
            NSValue *value = arr[i];
            
            CGPoint p = value.CGPointValue;
            
            
            UIBezierPath *pBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 5, 5)];
            [pBezier moveToPoint:p];
            //            [pBezier addArcWithCenter:p radius:13 startAngle:0 endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *pLayer = [CAShapeLayer layer];
            pLayer.frame = CGRectMake(0, 0, 5, 5);
            pLayer.position = p;
            pLayer.path = pBezier.CGPath;
            
            UIColor *color = _pointColorArr.count==_drawDataArr.count?(_pointColorArr[m]):(UIColorHex(@"5593E8"));
           
//            for (NSArray *valuesectionArr in _valueArr) {
//                for (int i=0; i<valuesectionArr.count; i++) {
//                    if([[NSString stringWithFormat:@"%@",valuesectionArr[i]] isEqualToString:@""]){
//                        pLayer.fillColor = [UIColor clearColor].CGColor;
//                    }else{
//                        pLayer.fillColor =color.CGColor;
//                    }
//                }
//            }
//            if (i==3) {
//                pLayer.fillColor = [UIColor orangeColor].CGColor;
//            }
            if([[NSString stringWithFormat:@"%@",_valueArr[m][i]] isEqualToString:@""]){
                 pLayer.fillColor = [UIColor clearColor].CGColor;
            }else{
//                if(i == 3){
//                    pLayer.fillColor = [UIColor orangeColor].CGColor;
//                }else{
                    pLayer.fillColor =color.CGColor;

//                }
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
