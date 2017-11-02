//
//  ReportHeader.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/11/2.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#ifndef ReportHeader_h
#define ReportHeader_h

#import "ReportModel.h"
#import "NSDate+MonthAndDay.h"
#import "CureReportViewController.h"
#import "WFLayoutHelper.h"
#import "ColorHelper.h"
#import "WFPropertyButton.h"
#import "ZFBarChart.h"

//物理宽度
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width
//物理高度
#define kScreenHeight [[UIScreen mainScreen]bounds].size.height

#define UIColorHex(_hex_)   [[[UIColor alloc] init] colorWithHexString:_hex_]

//颜色16进制
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//归档路径
#define kFilePath(kFileName)  [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:kFileName]

#define BarColor BaseColor //导航条 tabbar颜色
//判断设备
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6P (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

#define Style_Color_Content_BGColor UIColorFromRGB(0xefeff4)//页面背景色
#define Style_Color_Content_Blue UIColorFromRGB(0x5593e8) //字体蓝色
#define Style_Color_Content_Black UIColorFromRGB(0x212121) //字体黑色






#endif /* ReportHeader_h */
