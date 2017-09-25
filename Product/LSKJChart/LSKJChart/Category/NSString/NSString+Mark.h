//
//  NSString+Mark.h
//  ZYDZW3
//
//  Created by 王 良 on 15/4/5.
//  Copyright (c) 2015年 wangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHTMLStringNewLine @"-newline-"
#define kHTMLImageLabelBegin @"[img]"
#define kHTMLImageLabelEnd @"[/img]"

@interface NSString (Mark)

+ (BOOL)isPureInt:(NSString *)string;   //是否为数字

+ (BOOL)isMobile:(NSString *)string;    //是否为手机号
/*
 * 清除字符串首尾空格和换行
 */
+ (NSString *)stringClearWhitespace:(NSString *)str;
/*
 * 从数组的字典中根据key获取一个新的数组
 */
+(NSArray *)workKeysArrayFromArray:(NSArray *)array WithKey:(NSString *)key;
/*
 * 处理特殊字符串、格式化字符串
 */
+(NSString *)debugString:(NSString *)string;
/*
 * 判断字符串是否为空
 */
+ (Boolean)isEmptyOrNull:(NSString *)str;

/**
 * 将html字符串转换为定制字符串
 * @param content   html字符串
 * @return 定制字符串
 */
+(NSString *)StringFromHtmlString:(NSString *)htmlContent;
/*
 * 判断是否包含某个字符串
 */
+(BOOL)String:(NSString *)str containsString:(NSString *)str1;

+(CGSize)sizeFromLabel:(UILabel *)label Text:(NSString *)text;
//验证身份证是否合法
+ (BOOL)chk18PaperId:(NSString *) sPaperId;

@end
