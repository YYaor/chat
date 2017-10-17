//
//  NSString+md5String.h
//  MyDoctor
//
//  Created by 惠生 on 17/5/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (md5String)

/** md5 一般加密 */
+ ( NSString *)md5String:( NSString *)str;

/** md5 NB( 牛逼的意思 ) 加密 */
+ ( NSString *)md5StringNB:( NSString *)str;

/** 根据出生日期计算年龄 */
+ ( NSString *)getAgeFromBirthday:( NSString *)birthDate;

/** 获取会话iP */
+ (NSString*)getIpFromString:(NSString *)string;




@end
