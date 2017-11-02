//
//  GYRRadarChart.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "GYRRadarChart.h"
#import "GYRLegendView.h"
#import "YCBCatoryLabel.h"

#define PADDING             13
#define LEGEND_PADDING      3
#define ATTRIBUTE_TEXT_SIZE 10
#define COLOR_HUE_STEP      5
#define MAX_NUM_OF_COLOR    17
#define PI 3.141592653f

@interface GYRRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) GYRLegendView *legendView;
@property (nonatomic, strong) UIFont *scaleFont;

@property (nonatomic, assign) NSUInteger steps;                     //几个圈, 内部写死为4个
@property (nonatomic, strong) UIColor *backgroundLineColorRadial;   //背景线的颜色
@property (nonatomic, strong) UIColor *backgroundFillColor;         //背景色
@property (nonatomic, strong) NSMutableArray<UILabel*> *legendLabelArray;

@end

@implementation GYRRadarChart

- (NSMutableArray<UILabel *> *)legendLabelArray
{
    if (_legendLabelArray == nil)
    {
        _legendLabelArray = [NSMutableArray array];
    }
    
    return _legendLabelArray;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        [self setDefaultValues];
        self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues {
    self.backgroundColor = [UIColor whiteColor];
    _maxValue = 100.0;
    _centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
    _steps = 4;
    _drawPoints = YES;
    _showLegend = NO;
    _showStepText = NO;
    _showMarkLabel = YES;
    _fillArea = NO;
    _minValue = 0;
    _colorOpacity = 1.0;
    _backgroundLineColorRadial = UIColorFromRGB(0x5593e8);
    _backgroundFillColor = [UIColor whiteColor];

    _legendView = [[GYRLegendView alloc] init];
    _legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    _legendView.backgroundColor = [UIColor clearColor];
    _legendView.colors = [NSMutableArray array];
    _attributes = @[@"you", @"should", @"set", @"these", @"data", @"titles,",
                        @"this", @"is", @"just", @"a", @"placeholder"];
    _coutArrs = @[@"", @"", @"", @"", @"", @""];

    _scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE];
    
    _clockwise = YES;
}

- (void)setShowLegend:(BOOL)showLegend {
	_showLegend = showLegend;
	if (_showLegend) {
		[self addSubview:self.legendView];
	}
	else {
		for (UIView *subView in self.subviews) {
			if ([subView isKindOfClass:[GYRLegendView class]]) {
				[subView removeFromSuperview];
			}
		}
	}
}

- (void)setTitles:(NSArray *)titles {
	self.legendView.titles = titles;
}

- (void)setColors:(NSArray *)colors {
    [self.legendView.colors removeAllObjects];
    for (UIColor *color in colors) {
        [self.legendView.colors addObject:[color colorWithAlphaComponent:self.colorOpacity]];
    }
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[self.legendView sizeToFit];
	[self.legendView setNeedsDisplay];
}

- (void)setDataSeries:(NSArray *)dataSeries {
	_dataSeries = dataSeries;
	NSArray *arr = _dataSeries[0];
	_numOfV = [arr count];
	if (self.legendView.colors.count < _dataSeries.count) {
		for (int i = 0; i < _dataSeries.count; i++) {
			UIColor *color = [UIColor colorWithHue:1.0 * (i * COLOR_HUE_STEP % MAX_NUM_OF_COLOR) / MAX_NUM_OF_COLOR
			                            saturation:1
			                            brightness:1
			                                 alpha:self.colorOpacity];
			self.legendView.colors[i] = color;
		}
	}
}

- (void)layoutSubviews {
	[self.legendView sizeToFit];
	CGRect r = self.legendView.frame;
	r.origin.x = self.frame.size.width - self.legendView.frame.size.width - LEGEND_PADDING;
	r.origin.y = LEGEND_PADDING;
	self.legendView.frame = r;
	[self bringSubviewToFront:self.legendView];
}

- (void)drawRect:(CGRect)rect {    
    
    //NSArray *colorArr=@[COLOR1,COLOR2,COLOR3,COLOR4,COLOR5,COLOR6];
    
	NSArray *colors = [self.legendView.colors copy];
	CGFloat radPerV = M_PI * 2 / _numOfV;
    
    if (_clockwise) {
        radPerV =  - (M_PI * 2 / _numOfV);
    }
    else
    {
        radPerV = (M_PI * 2 / _numOfV);
    }
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	// 绘制标注文本
    CGFloat height = 20;
	//CGFloat height = [self.scaleFont lineHeight]+5;
	CGFloat padding = 2.0;
    
    
	for (int i = 0; i < _numOfV; i++) {
        
		NSString *attributeName = _attributes[i];
        NSNumber * count = nil;
        if (_coutArrs[i]) {
            count = _coutArrs[i];
        }else{
            count = @0;
        }
        
		CGPoint pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
        
		CGSize attributeTextSize = JY_TEXT_SIZE(attributeName, self.scaleFont);
		NSInteger width = attributeTextSize.width+10;
        
        BOOL xBol = pointOnEdge.x >= _centerPoint.x ;
        BOOL ybol = pointOnEdge.y >= _centerPoint.y;
        
		CGFloat xOffset = pointOnEdge.x >= _centerPoint.x ? width/ 20 + padding: -width / 2.0 - padding -15;
		CGFloat yOffset = pointOnEdge.y >= _centerPoint.y ? height / 30.0 + padding : -height / 2.0 - padding -25;
		CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset+15, pointOnEdge.y + yOffset +10);
        
        NSLog(@"%f",xOffset);
        NSLog(@"%f",yOffset);
        NSLog(@"123");
        

//        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        [paragraphStyle setLineBreakMode:NSLineBreakByClipping];
//        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
//        UIFont *labelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        NSDictionary *attributes = @{ NSFontAttributeName: labelFont,
//                                      NSParagraphStyleAttributeName: paragraphStyle,
//                                      NSForegroundColorAttributeName:[UIColor whiteColor]};
//        
//        [attributeName drawInRect:CGRectMake(legendCenter.x - width / 2.0,
//                                             legendCenter.y - height / 2.0,
//                                             width,
//                                             height)
//                   withAttributes:attributes];
        
        
        YCBCatoryLabel  * label=[[YCBCatoryLabel alloc]initWithFrame:CGRectMake(legendCenter.x - width / 2.0 - 5,
                                                                 legendCenter.y - height / 2.0,
                                                                 width+10,
                                                                  height)];
       // UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(legendCenter.x - width/ 2.0, legendCenter.y - height / 2.0 + 20, width, height)];
        NSString * co = [NSString stringWithFormat:@"%@", count];
//        label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.name.text = _attributes[i];
        if (self.showMarkLabel) {
            //显示分数
            if (co.intValue == 0) {
                //label.name = @"";
                label.markLabel.text = @"";
            }else{
                //label2.text = co;
                label.markLabel.text = co;
            }
            
        }else{
            label.markLabel.text = @"";
        }
        
//        label2.textAlignment = NSTextAlignmentCenter;
//        label2.userInteractionEnabled = YES;
        
        //label.backgroundColor=UIColorFromRGB(0x5593e8);
        //label.text=_attributes[i];
       // label.layer.cornerRadius  = height/2;
        //label.layer.masksToBounds = YES;
        //label.textAlignment=1;
        //label.textColor=[UIColor whiteColor];
        //label.font = labelFont;
        label.userInteractionEnabled = YES;
        
        [self.legendLabelArray addObject:label];

        // 添加触摸事件处理
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapEvent:)];
        [label addGestureRecognizer:singleTap];
        //[label2 addGestureRecognizer:singleTap];
        
        [self addSubview:label];
       // [self addSubview:label2];
        
    }

    //draw background fill color
    [_backgroundFillColor setFill];
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r);
    for (int i = 1; i <= _numOfV; ++i) {
        CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
                                _centerPoint.y - _r * cos(i * radPerV));
    }
    CGContextFillPath(context);

	// 绘制4个颜色渐变的背景圆形
	CGContextSaveGState(context);
    NSArray *colorArray = @[
                            UIColorFromRGB(0xf6f9fe),
                            UIColorFromRGB(0xe7f0fc),
                            UIColorFromRGB(0xd4e4f9),
                            UIColorFromRGB(0xc3d9f7),
                            ];
    for (int step = 1; step <= _steps; step++) {
        
        UIColor *color = colorArray[step - 1];
        CGFloat radius = _r / _steps * (_steps + 1 - step);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextAddArc(context, _centerPoint.x, _centerPoint.y, radius, 0, 2*PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    CGContextRestoreGState(context);
    
	// 绘制坐标线
	[_backgroundLineColorRadial setStroke];
    CGContextSetLineWidth(context, 1.0);
	for (int i = 0; i < _numOfV; i++) {
		CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
		CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
		                        _centerPoint.y - _r * cos(i * radPerV));
		CGContextStrokePath(context);
	}
        
    // 设置数据点之间的连线宽度
	CGContextSetLineWidth(context, 3.0);
    
	// 绘制数据点连线并做内部填充
    if (_numOfV > 0) {
        for (int serie = 0; serie < [_dataSeries count]; serie++) {
            if (self.fillArea) {
                [RGBACOLOR(0x55, 0x93, 0xe8, 0.6) setFill];
            }
            else {
                [colors[serie] setStroke];
            }

            for (int i = 0; i < _numOfV; ++i) {
                CGFloat value = [_dataSeries[serie][i] floatValue];
                if (i == 0) {
                    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
                }
                else {
                    CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV),
                            _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV));
                }
            }
            CGFloat value = [_dataSeries[serie][0] floatValue];
            CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);

            if (self.fillArea) {
                //CGContextFillPath(context);
                CGContextDrawPath(context, kCGPathFillStroke);
            }
            else {
                CGContextStrokePath(context);
            }

            // 绘制表示数据的点
            if (_drawPoints) {
                for (int i = 0; i < _numOfV; i++) {
                    CGFloat value = [_dataSeries[serie][i] floatValue];
                    CGFloat xVal = _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV);
                    CGFloat yVal = _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV);

                    [_backgroundLineColorRadial setFill];
                    CGContextFillEllipseInRect(context, CGRectMake(xVal - 4, yVal - 4, 8, 8));
                    [_backgroundLineColorRadial setFill];
                    CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
                }
            }
        }
    }
    
	if (self.showStepText) {
		//draw step label text, alone y axis
		//TODO: make this color a variable
		[[UIColor blackColor] setFill];
		for (int step = 0; step <= _steps; step++) {
			CGFloat value = _minValue + (_maxValue - _minValue) * step / _steps;
			NSString *currentLabel = [NSString stringWithFormat:@"%.0f", value];
			JY_DRAW_TEXT_IN_RECT(currentLabel,
			                     CGRectMake(_centerPoint.x + 3,
			                                _centerPoint.y - _r * step / _steps - 3,
			                                20,
			                                10),
			                     self.scaleFont);
		}
	}
}

-(void)handleSingleTapEvent:(UITapGestureRecognizer *)sender
{    
    if (sender.state == UIGestureRecognizerStateEnded &&
        [sender.view isKindOfClass:[UILabel class]])
    { 
        YCBCatoryLabel *labelTapped = (YCBCatoryLabel *)sender.view;
        if (labelTapped.markLabel.text.intValue > 0) {
            if (self.delegate)
            {
                [self.delegate radarMapLegendTappedHandler: labelTapped.name.text];
            }
            

        }else{
            if ([self.qnCodeStr isEqualToString:@"2"]) {
                //生活日记简单版报告
                //点击无反应
            }else{
                NSString * alert = [NSString stringWithFormat:@"%@%@", labelTapped.name.text, @"模块未填写"];
                [XHToast showCenterWithText:alert duration:2];
                
            }
            
            
        }
        
    }
}

// 加大图标的触摸面积使之易于选择
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UILabel *label in self.legendLabelArray)
    {
        CGRect labelBounds = CGRectInset(label.bounds, -20, -20);
        labelBounds = [self convertRect:labelBounds fromView:label];
        if (CGRectContainsPoint(labelBounds, point))
        {
            return label;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
