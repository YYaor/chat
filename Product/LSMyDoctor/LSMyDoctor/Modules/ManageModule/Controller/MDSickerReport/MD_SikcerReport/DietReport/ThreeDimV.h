//
//  ThreeDimV.h
//  new
//
//  Created by yunzujia on 16/10/25.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeDimV : UIView

// name: 早餐,午餐,晚餐
@property (nonatomic, copy ) NSString *namex;   //晚餐 (右下轴）
@property (nonatomic, copy ) NSString *namey;   //午餐 (左下轴）
@property (nonatomic, copy ) NSString *namez;   //早餐

//标准值,  总数为100，传入0～100数字
@property (nonatomic, assign) CGFloat standardx;    //晚餐
@property (nonatomic, assign) CGFloat standardy;    //午餐
@property (nonatomic, assign) CGFloat standardz;    //早餐

//实际值
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat z;

@end
