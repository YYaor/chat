//
//  NSDate+MonthAndDay.h
//  YouGeHealth
//
//  Created by 程兵 on 16/9/29.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (MonthAndDay)

+ (NSString *)getYearAndMonthAndDay;//获取年月日

+ (NSString *)getYesterdayYearAndMonthAndDay;//获取昨天的年月日

+ (NSString *)getMonthAndDay;//获取当前月和日

+ (NSInteger)getCurrentDate;//获取当前日期(20161029)

//获取本日前一周的周几字符串
+ (NSArray*)weekdayStringFromDateNday:(NSInteger) nDay;
//获取日期的日
+ (NSArray*)weekdayDayFromDateNday:(NSInteger) nDay;
//获取n天前的日期
+(NSString *)getNDay:(NSInteger)n;
//获取指定月的第一天和最后一天
+ (NSString *)getMonthBeginAndEndWith:(NSDate *)date;
//获取指定日期n天前的日期
+(NSString *)gettheDate:(NSString *)date BeforeNDay:(NSInteger)n;
//获取本日前一周的周几字符串（包含今天）
+ (NSArray*)weekdayStringFromToday;
//获取n天前的日期是周几（包含今天）
+ (NSArray*)weekdayDayFromTodayDateNday:(NSInteger) nDay;
//根据YYMMdd获取年月日
+ (NSString *)getYearAndMonthAndDayWithYYMMddDate:(NSString *)date;

@end
