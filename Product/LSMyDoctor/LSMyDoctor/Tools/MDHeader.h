//
//  MDHeader.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#ifndef MDHeader_h
#define MDHeader_h

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


#define BaseColor [UIColor colorFromHexString:LSGREENCOLOR]

#define Style_Color_Content_Black [UIColor colorFromHexString:@"212121"] //字体黑色



#endif /* MDHeader_h */
