//  饼状图
//  PieCharView.h
//  TestBtn
//
//  Created by 许文波 on 15/12/25.
//  Copyright © 2015年 许文波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieCharModel.h"

@interface PieCharView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGFloat textFont; // 字体大小
@property (nonatomic, strong) UIColor *textColor; // 字体颜色
@property (nonatomic, assign) CGFloat radius; // 半径


@property (nonatomic, strong) NSString *reportTypeStr; // 报告类型
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com