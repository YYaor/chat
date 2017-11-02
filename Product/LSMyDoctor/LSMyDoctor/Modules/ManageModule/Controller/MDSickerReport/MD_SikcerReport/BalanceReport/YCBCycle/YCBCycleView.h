//
//  YCBCycleView.h
//  cycle
//
//  Created by yunzujia on 16/11/9.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCBCusLabel;
@interface YCBCycleView : UIView
@property (nonatomic, assign) CGFloat workDrain;
@property (nonatomic, assign) CGFloat baseDrain;
@property (nonatomic, assign) CGFloat sportDrain;
@property (nonatomic, strong) YCBCusLabel * lab1 ;
@property (nonatomic,copy) NSString *firstTitleStr;//提交按钮标题
@property (nonatomic,copy) NSString *secondTitleStr;//提交按钮标题
@property (nonatomic,copy) NSString *thirdTitleStr;//提交按钮标题
@property (nonatomic,copy) NSString *unit;//提交按钮标题


@end
