//
//  WFHelperButton.m
//  YouGeHealth
//
//  Created by earlyfly on 16/11/1.
//
//

#import "WFHelperButton.h"
#import <objc/runtime.h>
#define PADDING     5
static void *DragEnableKey = &DragEnableKey;
static void *AdsorbEnableKey = &AdsorbEnableKey;

@interface WFHelperButton ()

@property (nonatomic,assign) BOOL isMoved;

@end

@implementation WFHelperButton


-(void)setDragEnable:(BOOL)dragEnable
{
    objc_setAssociatedObject(self, DragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable
{
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}

-(void)setAdsorbEnable:(BOOL)adsorbEnable
{
    objc_setAssociatedObject(self, AdsorbEnableKey,@(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAdsorbEnable
{
    return [objc_getAssociatedObject(self, AdsorbEnableKey) boolValue];
}

CGPoint beginPoint;
CGPoint beginPoint1;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isMoved = NO;
    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    beginPoint1 = [touch locationInView:[self superview]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint1 = [touch locationInView:[self superview]];
    NSLog(@"x:%lf-%lf",beginPoint1.x,nowPoint1.x);
    NSLog(@"y:%lf-%lf",beginPoint1.y,nowPoint1.y);
    float offsetX1 = nowPoint1.x - beginPoint1.x;
    float offsetY1 = nowPoint1.y - beginPoint1.y;
    NSLog(@"%lf-%lf",offsetX1,offsetY1);
    NSLog(@"%lf-%lf",fabsf(offsetX1),fabsf(offsetY1));
    if (fabsf(offsetX1) >= 0.8f || fabsf(offsetY1) >= 0.8f) {
        
//        NSLog(@"移动了");
        _isMoved = YES;
    }
    
    CGPoint nowPoint = [touch locationInView:self];
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    float centerY = self.center.y + offsetY;
    //当存在导航栏，进行的处理
    if (centerY < 104) {
        centerY = 104;
    }
    
    self.center = CGPointMake(self.center.x + offsetX, centerY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

//    NSLog(@"%@",_isMoved?@"移动":@"未移动");
//    NSLog(@"%@",self.highlighted?@"高亮":@"非高亮");
    if (_isMoved) {
        if (self.highlighted) {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            self.highlighted = NO;
        }
        
        if (self.superview && [objc_getAssociatedObject(self,AdsorbEnableKey) boolValue] ) {
            float marginLeft = self.frame.origin.x;
            float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
            float marginTop = self.frame.origin.y;
            float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
            [UIView animateWithDuration:0.125 animations:^(void){
                if (marginTop<60) {
                    self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?self.superview.frame.size.width -self.frame.size.width-PADDING:self.frame.origin.x,
                                            PADDING,
                                            self.frame.size.width,
                                            self.frame.size.height);
                }
                else if (marginBottom<60) {
                    self.frame = CGRectMake(marginLeft<marginRight?marginLeft<PADDING?PADDING:self.frame.origin.x:marginRight<PADDING?self.superview.frame.size.width -self.frame.size.width-PADDING:self.frame.origin.x,
                                            self.superview.frame.size.height - self.frame.size.height-PADDING,
                                            self.frame.size.width,
                                            self.frame.size.height);
                    
                }
                else {
                    self.frame = CGRectMake(marginLeft<marginRight?PADDING:self.superview.frame.size.width - self.frame.size.width-PADDING,
                                            self.frame.origin.y,
                                            self.frame.size.width,
                                            self.frame.size.height);
                }
            }];
            
        }
    }else{
        
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        if (self.highlighted) {
            self.highlighted = NO;
        }
    }
//     NSLog(@"%@",self.highlighted?@"高亮":@"非高亮");
}
- (void)setPicString:(NSString *)picString
{
    _picString = picString;
}
- (void)setFlagStr:(NSString *)flagStr
{
    _flagStr = flagStr;
}

@end
