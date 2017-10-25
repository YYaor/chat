//
//  YGPageControl.m
//  YouGeHealth
//
//  Created by earlyfly on 16/11/28.
//
//

#import "YGPageControl.h"

#define dotW 16
#define activeDotW 6
#define magrin 50

@implementation YGPageControl

#pragma mark - 改变pageControl圆点大小及圆点间距
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX + dotW;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y - 1, dotW, dotW)];
        }else {
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
        }
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = 8;
    }
}

@end
