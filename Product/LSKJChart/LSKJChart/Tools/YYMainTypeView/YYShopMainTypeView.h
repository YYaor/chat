//
//  YYShopMainTypeView.h
//  mocha
//
//  Created by 向文品 on 14-8-4.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MainFilterHeight 35

typedef NS_ENUM(NSInteger, horizontalViewType) {
    //仅显示文字的横滑条
    horizontalViewTextType = 0,
    //左图片、右文字的横滑条
    horizontalViewTypeLeftImageAndRightTextType = 1
};

@protocol YYShopMainTypeViewDelegate <NSObject>

-(void)selectTypeIndex:(NSInteger)index;

@end

@interface YYShopMainTypeView : UIView

@property (nonatomic,weak) id<YYShopMainTypeViewDelegate>delegate;
@property (nonatomic,assign) BOOL isJingxuan;
//是否显示选择状态下面的横条
-(void)hideSelectedView;

/**
 *  用于创建类似首页导航栏中间视图的方法，注意该方法与PureLayout冲突
 *
 *  @param frame   视图的frame
 *  @param filters 需要的模块数组
 *  @param isJing  模块被选择时字体是否变粗
 *  @param horizontalViewType  横条展示的形式:仅文字、左图片右文字
 *
 *  @return view
 */
//如果是左图片、右文字的横滑条的类型的话要设置图片数组
-(id)initFrame:(CGRect)frame filters:(NSArray *)filters picNormalArr:(NSArray*)pictureNameNormalArr picSelectedArr:(NSArray*)pictureNameSelectedArr isJingxuan:(BOOL)isJing viewType:(horizontalViewType)horizontalViewType;

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters;

-(void)selectToValue:(float)offestX;

-(void)selectToIndex:(NSInteger)index;

-(void)updateFilters:(NSArray *)filters;

@end
