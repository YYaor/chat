//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"

@interface JHColumnChart ()

//背景图
@property (nonatomic,strong)UIScrollView *BGScrollView;



//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;

@property (nonatomic,assign) CGFloat perHeight;
@end

@implementation JHColumnChart


-(NSMutableArray *)showViewArr{
    
    
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    
    return _showViewArr;
    
}

-(NSMutableArray *)layerArr{
    
    
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    
    return _layerArr;
}


-(UIScrollView *)BGScrollView{
    
    
    if (!_BGScrollView) {

        _BGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height-10)];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
        _BGScrollView.backgroundColor = _bgVewBackgoundColor;
        [self addSubview:_BGScrollView];
        
    }
    
    return _BGScrollView;
    
    
}


-(void)setBgVewBackgoundColor:(UIColor *)bgVewBackgoundColor{
    
    _bgVewBackgoundColor = bgVewBackgoundColor;
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
}


-(NSMutableArray *)yLineDataArr{
    
    
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        _needXandYLine = YES;
       
    }
    return self;
    
}

-(void)setMaxHeight:(CGFloat)maxHeight{
    _maxHeight=maxHeight;
}

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    
    
    _valueArr = valueArr;
    CGFloat max = 0;
 
    for (NSArray *arr in _valueArr) {
        
        for (id number in arr) {
            
            CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
            if (currentNumber>max) {
                max = currentNumber;
            }
            else{
                max=_maxHeight;
            }
        }

    }
    
    if (max<5.0) {
        _maxHeight = 5.0;
    }else if(max<10){
        _maxHeight = 10;
    }else{
        
    }
    
    _maxHeight += 4;
    _perHeight = (CGRectGetHeight(self.frame) -70 - _originSize.y)/_maxHeight;
    
}


-(void)showAnimation{
    
    
    
    [self clear];
    
    _columnWidth = (_columnWidth<=0?30:_columnWidth);
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?5:_typeSpace);
    _maxWidth = count * _columnWidth + _valueArr.count * _typeSpace + _typeSpace + 40;
    if (_xShowInfoText.count>7) {
        self.BGScrollView.contentSize = CGSizeMake(_maxWidth+25, 0);
    }else{
        self.BGScrollView.contentSize = CGSizeMake(kScreenWidth, 0);
    }
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
        
        [bezier addLineToPoint:P_M(self.originSize.x, 20)];
        
//        
//        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];
//    
//        [bezier addLineToPoint:P_M(_maxWidth , CGRectGetHeight(self.frame) - self.originSize.y)];
        
        
        layer.path = bezier.CGPath;
        
//        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        layer.strokeColor = UIColorHex(@"41d07d").CGColor;
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = 1.5;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
        //X轴
        [self creatX];
//        _maxHeight += 4;
        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i<=_yDataArr.count; i++) {
            NSInteger pace = (_maxHeight) / [[_yDataArr lastObject] floatValue];
            CGFloat height =0;
            if (i != _yDataArr.count) {
                height = _perHeight * ([_yDataArr[i] floatValue])*pace;
            }
            [second moveToPoint:P_M(_originSize.x, CGRectGetHeight(self.frame) - _originSize.y -height)];
            [second addLineToPoint:P_M(_maxWidth, CGRectGetHeight(self.frame) - _originSize.y - height)];
            
            
            
            CATextLayer *textLayer = [CATextLayer layer];
            NSString *text =@"";
            textLayer.contentsScale = [UIScreen mainScreen].scale;
             if (i != _yDataArr.count) {
                 text =[NSString stringWithFormat:@"%@",_yNameArr[i]] ;
             }
            CGFloat be = [self getTextWithWhenDrawWithText:text];
            CGFloat originX = self.originSize.x - 20;
            if (text.length >= 4) {
                originX -= 5;
            }
            textLayer.frame = CGRectMake(originX, CGRectGetHeight(self.frame) - _originSize.y -height - 5, be, 15);
            
            UIFont *font = [UIFont boldSystemFontOfSize:10];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = text;
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];
            //修改
            if (i==4) {
                UILabel *nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.originSize.x + 3, 5, 50, 20)];
                nameLbl.text=_yName;
                nameLbl.font=[UIFont boldSystemFontOfSize:10];
//                nameLbl.backgroundColor=[UIColor yellowColor];
                nameLbl.textColor=[UIColor darkGrayColor];
                
                [_BGScrollView addSubview:nameLbl];
//                //您的标准区间
//                CGFloat rightLblLen = [[NSString stringWithFormat:@"%@",_blueName] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
//                CGFloat border=0;
//                UILabel *rightLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-10-rightLblLen, 15, rightLblLen, 20)];
//                rightLbl.text=_blueName;
//                rightLbl.font=[UIFont systemFontOfSize:12];
////                nameLbl.backgroundColor=[UIColor yellowColor];
//                rightLbl.textColor=[UIColor lightGrayColor];
//                [self addSubview:rightLbl];
//                //您的标准区间颜色
//                UILabel *rightLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-20-rightLblLen-40, 15, 40, 20)];
//                rightLblColor.text=@"";
////                nameLbl.font=[UIFont systemFontOfSize:14];
//                rightLblColor.backgroundColor=UIColorHex(@"5593E8");
////                nameLbl.textColor=[UIColor blueColor];
//                [self addSubview:rightLblColor];
//                //您的值
//                CGFloat leftLblLen = [[NSString stringWithFormat:@"%@",_yellowName] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
//
//                UILabel *leftLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70-rightLblLen-leftLblLen, 15, leftLblLen, 20)];
//                leftLbl.text=_yellowName;
//                leftLbl.font=[UIFont systemFontOfSize:12];
//                //                nameLbl.backgroundColor=[UIColor yellowColor];
//                leftLbl.textColor=[UIColor lightGrayColor];
//                [self addSubview:leftLbl];
//                //您的值颜色
//                UILabel *leftLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120-rightLblLen-leftLblLen, 15, 40, 20)];
//                leftLblColor.text=@"";
//                leftLblColor.font=[UIFont systemFontOfSize:12];
//                leftLblColor.backgroundColor=UIColorHex(@"FFB434");
////                leftLblColor.textColor=[UIColor lightGrayColor];
//                [self addSubview:leftLblColor];
//                
//                leftLbl.hidden=_isHiddenLegend;
//                leftLblColor.hidden=_isHiddenLegend;
//                rightLbl.hidden=_isHiddenLegend;
//                rightLblColor.hidden=_isHiddenLegend;
                
            }

        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = second.CGPath;
        
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor greenColor].CGColor):_dashColor.CGColor);
        
        shapeLayer.lineWidth = 0.5;
        
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic2.duration = 1.5;
        
        basic2.fromValue = @(0);
        
        basic2.toValue = @(1);
        
        basic2.autoreverses = NO;
        
        
        
        basic2.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:basic2 forKey:nil];
        
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
    }
    
    
    

    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    //_xShowInfoText.count == _valueArr.count&&
    if (_xShowInfoText.count>0) {
        
        NSInteger count = [_valueArr[0] count];
        
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            

            
            CATextLayer *textLayer = [CATextLayer layer];
            
            CGFloat wid =  count * _columnWidth *2.5;
            if (_xShowInfoText.count<=7) {
                wid =  count * _columnWidth *1.4;
            }
            
            
            CGSize size = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} context:nil].size;
            if (_xShowInfoText.count>7) {
                textLayer.frame = CGRectMake( (i+1) * (count * _columnWidth + _typeSpace)  + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
                if (_xShowInfoText.count-1 ==i) {
                    textLayer.frame = CGRectMake( i * (count * _columnWidth + _typeSpace)  + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
                }
            }else{
                textLayer.frame = CGRectMake( i * (count * _columnWidth + _typeSpace)  + _originSize.x, CGRectGetHeight(self.frame) - _originSize.y+5,wid, size.height);
            }
            
           
            if ([_xShowInfoText[i] isEqualToString:@""]) {
                textLayer.hidden=YES;
            }else{
                textLayer.hidden=NO;
                textLayer.string = _xShowInfoText[i];
            }
            
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont boldSystemFontOfSize:10];
            

            
            textLayer.fontSize = font.pointSize;
            
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            textLayer.alignmentMode = kCAAlignmentCenter;
            
            [_BGScrollView.layer addSublayer:textLayer];
            
            [self.layerArr addObject:textLayer];
            
            if(i==_xShowInfoText.count-1){
//                UILabel *xShowLbl=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textLayer.frame)-10, CGRectGetHeight(self.frame) - _originSize.y+5, 40, size.height)];
//                xShowLbl.backgroundColor=[UIColor blueColor];
//                xShowLbl.textColor=[UIColor blackColor];
//                xShowLbl.text=@"日期";
//                xShowLbl.font=[UIFont systemFontOfSize:12];
                
                CGSize sizeD= [@"日期" boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} context:nil].size;
                CATextLayer *textDateLayer = [CATextLayer layer];
                textDateLayer.frame = CGRectMake(_BGScrollView.contentSize.width-sizeD.width-2 , CGRectGetHeight(self.frame) - _originSize.y+4,sizeD.width, size.height);
                textDateLayer.string = @"日期";
//                textDateLayer.backgroundColor=[UIColor redColor].CGColor;
                textDateLayer.contentsScale = [UIScreen mainScreen].scale;
                UIFont *font = [UIFont boldSystemFontOfSize:10];
                
                
                
                textDateLayer.fontSize = font.pointSize;
                
                textDateLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
                textDateLayer.alignmentMode = kCAAlignmentCenter;
//                _BGScrollView.backgroundColor=[UIColor greenColor];
                [_BGScrollView.layer addSublayer:textDateLayer];

//                [_BGScrollView addSubview:xShowLbl];
            }
        }
        
        
    }
    
    
    
    
    NSInteger border=0;
    if (_xShowInfoText.count>7) {
        border =(_BGScrollView.contentSize.width-_originSize.x-25)/7;
    }
  
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        
        
        NSArray *arr = _valueArr[i];

        for (NSInteger j = 0; j<arr.count; j++) {
            

            CGFloat height =[arr[j] floatValue] *_perHeight;
            CGFloat testViewHeight=height-[_testViewHArr[i] floatValue] *_perHeight;

            UIView *itemsView = [UIView new];
            [self.showViewArr addObject:itemsView];
            itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace+border, CGRectGetHeight(self.frame) - _originSize.y-1, _columnWidth, 0);
            itemsView.backgroundColor = (UIColor *)(_columnBGcolorsArr.count<arr.count?[UIColor greenColor]:_columnBGcolorsArr[j]);
            //modify
            UIView *testView = [UIView new];
            if (j==1) {
                
                [self.showViewArr addObject:testView];
                testView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace+border, CGRectGetHeight(self.frame) - _originSize.y-1, _columnWidth, 0);
                testView.backgroundColor =UIColorHex(@"5593E8");
            }
            [UIView animateWithDuration:1 animations:^{
                
                 itemsView.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace+border, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, height);
                 testView.frame= CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace+border, CGRectGetHeight(self.frame) - height - _originSize.y -1, _columnWidth, testViewHeight);
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    
                    CATextLayer *textLayer = [CATextLayer layer];
                    
                    [self.layerArr addObject:textLayer];
                    NSString *str = [NSString stringWithFormat:@"%@",arr[j]];
                    
                    CGSize size = [str boundingRectWithSize:CGSizeMake(_columnWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} context:nil].size;
                    
                    textLayer.frame = CGRectMake((i * arr.count + j)*_columnWidth + i*_typeSpace+_originSize.x + _typeSpace, CGRectGetHeight(self.frame) - height - _originSize.y -3 - size.width, _columnWidth, size.height);
                    if ([str isEqualToString:@"0"]) {
                        textLayer.string = @"";
                    }else{
                         textLayer.string = @"";
                    }
                   
                    
                    textLayer.fontSize = 9.0;
                    
                    textLayer.alignmentMode = kCAAlignmentCenter;
                    textLayer.contentsScale = [UIScreen mainScreen].scale;
                    textLayer.foregroundColor = itemsView.backgroundColor.CGColor;
                    
                    [_BGScrollView.layer addSublayer:textLayer];
                    
                }
                
            }];
            
            [self.BGScrollView addSubview:itemsView];
            [self.BGScrollView addSubview:testView];

        }
        
    }
    
    
    
    
    
}


-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
}


-(void)creatX{
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, CGRectGetHeight(self.frame) - self.originSize.y)];

        [bezier addLineToPoint:P_M(_maxWidth , CGRectGetHeight(self.frame) - self.originSize.y)];
        
        
        layer.path = bezier.CGPath;
        
        layer.strokeColor = UIColorHex(@"41d07d").CGColor;
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = 1.5;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
    }
}






@end
