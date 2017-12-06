//
//  NSDate+MonthAndDay.m
//  YouGeHealth
//
//  Created by 程兵 on 16/9/29.
//
//

#import "NSDate+MonthAndDay.h"

@implementation NSDate (MonthAndDay)

+ (NSString *)getYearAndMonthAndDay{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    // [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];//将NSDate  ＊对象 转化为 NSString ＊对象。
    
    return currentTime;
}

+ (NSString *)getYesterdayYearAndMonthAndDay{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    // [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *currentTime = [formatter stringFromDate:yesterday];//将NSDate  ＊对象 转化为 NSString ＊对象。
    
    return currentTime;
}

+ (NSString *)getMonthAndDay{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init]; //初始化格式器。
    // [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];//定义时间为这种格式： YYYY-MM-dd hh:mm:ss 。
    [formatter setDateFormat:@"MM月dd日"];
    
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];//将NSDate  ＊对象 转化为 NSString ＊对象。
    
//    int b = [[currentTime substringWithRange:NSMakeRange(3,2)] intValue];
//    int c = [[currentTime substringWithRange:NSMakeRange(0,2)] intValue];
//    
//    NSString *strA = [NSString stringWithFormat:@"%d",b];
//    NSString *strC = [NSString stringWithFormat:@"%d",c];
    
    NSString *strA = [currentTime substringWithRange:NSMakeRange(3,2)];
    
    NSString *strC = [currentTime substringWithRange:NSMakeRange(0,2)];
    
    return [NSString stringWithFormat:@"%@月%@日",strC,strA];
}

+ (NSInteger)getCurrentDate{
    
    NSDateFormatter *formatterM = [[NSDateFormatter alloc] init];
    formatterM.dateFormat = @"YYYYMMdd";
    NSString *date = [formatterM stringFromDate:[NSDate date]];
    
    return [date integerValue];
}

+ (NSString *)getCurrentDateString
{
    NSDateFormatter *formatterM = [[NSDateFormatter alloc] init];
    formatterM.dateFormat = @"YYYY-MM-dd";
    NSString *date = [formatterM stringFromDate:[NSDate date]];
    
    return date;
}

//获取本日前一周的周几字符串（不包含今天）
+ (NSArray*)weekdayStringFromDateNday:(NSInteger) nDay {
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = -7; i <= -1; ++i) {
        NSString *dateStr = [NSDate getNDay:i];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"YYYYMMdd"];
        NSDate* inputDate = [inputFormatter dateFromString:dateStr];
        [dates addObject:[NSDate weekdayStringFromDate:inputDate]];
    }
    return dates;
    
}
//获取前一周的日期是周几（不包含几天）
+ (NSArray*)weekdayDayFromDateNday:(NSInteger) nDay {
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = -7; i <= -1; ++i) {
        NSString *dateStr = [NSDate getNDay:i];
        
        [dates addObject:dateStr];
//        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//        [inputFormatter setDateFormat:@"YYYYMMdd"];
//        NSDate* inputDate = [inputFormatter dateFromString:dateStr];
        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
//        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:inputDate];
//        
//        NSString *day = [NSString stringWithFormat:@"%ld",[dateComponent day]];
//        
//        [dates addObject:day];
    }
    return dates;
    
}

//获取本日前一周的周几字符串（包含今天）
+ (NSArray*)weekdayStringFromToday{
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = -6; i <= 0; ++i) {
        NSString *dateStr = [NSDate getNDay:i];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"YYYYMMdd"];
        NSDate* inputDate = [inputFormatter dateFromString:dateStr];
        [dates addObject:[NSDate weekdayStringFromDate:inputDate]];
    }
    return dates;
    
}
//获取n天前的日期是周几（包含今天）
+ (NSArray*)weekdayDayFromTodayDateNday:(NSInteger) nDay {
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (int i = (-1 * nDay) + 1; i <= 0; ++i) {
        NSString *dateStr = [NSDate getNDay:i];
        
        [dates addObject:dateStr];
        //        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        //        [inputFormatter setDateFormat:@"YYYYMMdd"];
        //        NSDate* inputDate = [inputFormatter dateFromString:dateStr];
        
        //        NSCalendar *calendar = [NSCalendar currentCalendar];
        //        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
        //        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:inputDate];
        //
        //        NSString *day = [NSString stringWithFormat:@"%ld",[dateComponent day]];
        //
        //        [dates addObject:day];
    }
    return dates;
    
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    //    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//获取n天前的日期
+(NSString *)getNDay:(NSInteger)n{
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(n!=0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYYMMdd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}
//获取指定日期n天前的日期
+(NSString *)gettheDate:(NSString *)date BeforeNDay:(NSInteger)n {
    
    NSDateFormatter *formatterM = [[NSDateFormatter alloc] init];
    formatterM.dateFormat = @"YYYYMMdd";
    formatterM.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSDate *nowDate = [formatterM dateFromString:date];
    
    NSDate * theDate;
    if(n!=0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeInterval:oneDay*n sinceDate:nowDate];//initWithTimeIntervalSinceNow是从指定往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYYMMdd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}

//获取指定月的第一天和最后一天
+ (NSString *)getMonthBeginAndEndWith:(NSDate *)date{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return s;
}

//根据YYMMdd获取年月日
+ (NSString *)getYearAndMonthAndDayWithYYMMddDate:(NSString *)date{
    
    NSString *year = [date substringToIndex:4];
    NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [date substringWithRange:NSMakeRange(6, 2)];
    
    return [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:anyDate];
    NSDate *localeDate = [anyDate dateByAddingTimeInterval:interval];
    return localeDate;
}


@end
