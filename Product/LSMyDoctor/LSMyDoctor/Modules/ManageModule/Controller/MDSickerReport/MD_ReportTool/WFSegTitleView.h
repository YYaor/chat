//
//  WFSegTitleView.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/18.
//
//

#import <UIKit/UIKit.h>


//@protocol SegmentClick <NSObject>
//
//-(void)showAllInfo;
//
//@end

@interface WFSegTitleView : UIView

@property (nonatomic,assign) CGFloat numOfScreenW;//屏幕宽显示几个tab

//选中分段的下标
@property(nonatomic, assign) NSUInteger selectedSegmentIndex;

//选中颜色
@property(nonatomic, strong) UIColor * selectedColor;

//是否显示分割线
@property(nonatomic, assign) BOOL showLine;

//@property(nonatomic,weak) id<SegmentClick> delegate;

//通过items去创建segmentControl对象
- (instancetype)initWithItems:(NSArray *)items;
//添加事件
- (void)addTarget:(id)target action:(SEL)action;

- (void)tabDidSelectTabAtIndex:(NSInteger)index;


@end
