//
//  LSPrefixHeader.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#ifndef LSPrefixHeader_h
#define LSPrefixHeader_h

//宏
#define LSBASEURL @"http:www.baidu.com"

#define LSSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define LSSCREENHEIGHT [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define LSX(v)       (v).frame.origin.x
#define LSY(v)       (v).frame.origin.y
#define LSWIDTH(v)   (v).frame.size.width
#define LSHEIGHT(v)  (v).frame.size.height

#define LSGREENCOLOR @"3ED0B4"//绿色
#define LSPURPLECOLOR @"7B77E5"//紫色
#define LSPINKCOLOR @"ED97C1"//粉色
#define LSYELLOWCOLOR @"F7BA27"//黄色
#define LSBLUECOLOR @"31D2DF"//蓝色
#define LSTIPCOLOR @"FE7F51"//提醒
#define LSDARKGRAYCOLOR @"9E9E9E"//深灰 字体
#define LSLIGHTGRAYCOLOR @"EFEFEF"//浅灰 分割线
#define LSSKYCOLOR @"F0FBFF"//天空蓝


//第三方

//网络
#import "AFNetworking.h"
//网络图片
#import "UIKit+AFNetworking.h"
//颜色
#import "Colours.h"
//适配
#import "Masonry.h"
//提示框
#import "RKDropdownAlert.h"
//刷新
#import "MJRefresh.h"
//键盘
#import "IQKeyboardManager.h"
//菊花
#import "BlocMBProgressHUD.h"
//通用工具类
#import "LSUtil.h"
//model解析
#import "YYModel.h"
//日历
#import "FSCalendar.h"
//环信
#import <HyphenateLite/HyphenateLite.h>
#import "EaseUI.h"
//UITextView
#import "YYPlaceholderTextView.h"

#endif /* LSPrefixHeader_h */
