//
//  ZFBarChart.m
//  ZFChartView
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFBarChart.h"
#import "ZFGenericChart.h"
#import "ZFBar.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"

@interface ZFBarChart()<UIScrollViewDelegate>

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericChart * genericChart;
/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;
/** 存储柱状条的数组 */
@property (nonatomic, strong) NSMutableArray * barArray;

@end

@implementation ZFBarChart

- (NSMutableArray *)barArray{
    if (!_barArray) {
        _barArray = [NSMutableArray array];
    }
    return _barArray;
}

/**
 *  初始化变量
 */
- (void)commonInit{
    _isShowValueOnChart = YES;
    _valueOnChartFontSize = 10.f;
    _isShadow = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
        
        //标题Label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.backgroundColor = [UIColor redColor];
//        self.titleLabel.text = @"分数";
        self.titleLabel.textColor = UIColorFromRGB(0xa0a0a0);
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawGenericChart{
    self.genericChart = [[ZFGenericChart alloc] initWithFrame:self.bounds];
    [self addSubview:self.genericChart];
}

#pragma mark - 柱状条

/**
 *  画柱状条
 */
- (void)drawBar{
    [self removeAllBar];
    [self removeLabelOnChart];
    
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        
        CGFloat xPos = self.genericChart.axisStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength+ 50 - 12*(self.xLineTitleArray.count - 0.5) ) * i;
        
        CGFloat yPos = self.genericChart.yLineMaxValueYPos;
        
        CGFloat width = XLineItemWidth;//宽度
        if (self.xLineTitleArray.count > 3) {
            width = (kScreenWidth - ZFAxisLineStartXPos - 12*(self.xLineTitleArray.count + 1)) / self.xLineTitleArray.count ;
        }
        CGFloat height = self.genericChart.yLineMaxValueHeight;
        
        ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        
        //当前数值超过y轴显示上限时，柱状改为红色
        if ([self.xLineValueArray[i] floatValue] / _yLineMaxValue <= 1) {
            bar.percent = [self.xLineValueArray[i] floatValue] / _yLineMaxValue;
            //柱状颜色转换
            if (self.xLineTitleArray.count > 3) {
                //如果数量超过3个，全部为蓝色
                bar.barBackgroundColor = UIColorFromRGB(0x5895e5);
                
            }else{
                
                if (i == 0) {
                    bar.barBackgroundColor = UIColorFromRGB(0x5ede9a);
                }else if (i == 1) {
                    bar.barBackgroundColor = UIColorFromRGB(0x5895e5);
                }else{
                    bar.barBackgroundColor = UIColorFromRGB(0xfb6e49);
                }
            }
            
            
        }else{
            bar.percent = 1.f;
            bar.barBackgroundColor = [UIColor redColor];
        }
        bar.isShadow = _isShadow;
        [bar strokePath];
        [self.barArray addObject:bar];
        [self addSubview:bar];
    }
    
    _isShowValueOnChart ? [self showLabelOnChart] : nil;
}

/**
 *  显示bar上的label
 */
- (void)showLabelOnChart{
    for (NSInteger i = 0; i < self.barArray.count; i++) {
        ZFBar * bar = self.barArray[i];
        //label的中心点
//        CGPoint label_center = CGPointMake(bar.center.x , bar.endYPos + self.genericChart.yLineEndYPos);
//        CGRect rect = [self.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(bar.frame.size.width , 30) fontOfSize:_valueOnChartFontSize isBold:NO];
//        
        
        CGFloat xPos = bar.center.x - (50 - 10*(self.xLineTitleArray.count - 3));
        if (self.xLineTitleArray.count <= 3) {
            xPos = bar.center.x - 18;
        }else if (self.xLineTitleArray.count == 4){
            xPos = xPos - 5;
        }
        
        CGFloat yPos = bar.endYPos + self.genericChart.yLineEndYPos - 7;
        
        CGFloat width = XLineItemWidth;//宽度
        if (self.xLineTitleArray.count > 3) {
            width = (kScreenWidth - ZFAxisLineStartXPos - 10*(self.xLineTitleArray.count + 1)) / self.xLineTitleArray.count ;
        }
        
        CGFloat height = 30;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
        label.text = self.xLineValueArray[i];
        label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
        label.numberOfLines = 0;
//        label.center = label_center;
        label.isFadeInAnimation = YES;
        [self addSubview:label];
    }
}

/**
 *  清除之前所有柱状条
 */
- (void)removeAllBar{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ZFBar class]]) {
            [(ZFBar *)view removeFromSuperview];
        }
    }
}

/**
 *  清除圆环上的Label
 */
- (void)removeLabelOnChart{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.genericChart strokePath];
    [self drawBar];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.genericChart.frame), self.frame.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self滚动时，标题保持相对不动
    self.titleLabel.frame = CGRectMake(self.contentOffset.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

#pragma mark - 重写setter,getter方法

- (void)setXLineTitleArray:(NSMutableArray *)xLineTitleArray{
    _xLineTitleArray = xLineTitleArray;
    self.genericChart.xLineTitleArray = _xLineTitleArray;
}

- (void)setXLineValueArray:(NSMutableArray *)xLineValueArray{
    _xLineValueArray = xLineValueArray;
    self.genericChart.xLineValueArray = _xLineValueArray;
}

- (void)setYLineMaxValue:(float)yLineMaxValue{
    _yLineMaxValue = yLineMaxValue;
    self.genericChart.yLineMaxValue = _yLineMaxValue;
}

- (void)setYLineSectionCount:(NSInteger)yLineSectionCount{
    _yLineSectionCount = yLineSectionCount;
    self.genericChart.yLineSectionCount = _yLineSectionCount;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setXLineTitleFontSize:(CGFloat)xLineTitleFontSize{
    _xLineTitleFontSize = xLineTitleFontSize;
    self.genericChart.xLineTitleFontSize = _xLineTitleFontSize;
}

- (void)setXLineValueFontSize:(CGFloat)xLineValueFontSize{
    _xLineValueFontSize = xLineValueFontSize;
    self.genericChart.xLineValueFontSize = _xLineValueFontSize;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
