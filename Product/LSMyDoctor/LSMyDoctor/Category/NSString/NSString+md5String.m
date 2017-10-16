//
//  NSString+md5String.m
//  MyDoctor
//
//  Created by 惠生 on 17/5/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+md5String.h"

@implementation NSString (md5String)

+ ( NSString *)md5String:( NSString *)str

{
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    for ( int i = 0 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]];
        
    }
    
    return md5String;
    
}

+ ( NSString *)md5StringNB:( NSString *)str

{
    
    const char *myPasswd = [str UTF8String ];
    
    unsigned char mdc[ 16 ];
    
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    
    NSMutableString *md5String = [ NSMutableString string ];
    
    [md5String appendFormat : @"%02x" ,mdc[ 0 ]];
    
    for ( int i = 1 ; i< 16 ; i++) {
        
        [md5String appendFormat : @"%02x" ,mdc[i]^mdc[ 0 ]];
        
    }
    
    return md5String;
    
}

+ ( NSString *)getAgeFromBirthday:( NSString *)birthDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSString *birth = [birthDate stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
    if([date year] >0){
        
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ;
        return [NSString stringWithFormat:@"%ld岁",(long)[date year]];
        
    }else if([date month] >0){
        
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]);
        return [NSString stringWithFormat:@"%ld月",(long)[date month]];
        
    }else if([date day]>0){
        
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]);
        return [NSString stringWithFormat:@"%ld天",(long)[date day]];
        
    }else {
        return @"0岁";
    }
    
}

+ (NSString*)getIpFromString:(NSString *)string
{
    NSString* last = [string substringFromIndex:[string rangeOfString:@"//"].location + 2 ];
    NSString* midle = [last substringToIndex:[last rangeOfString:@"/"].location];
    if ([midle rangeOfString:@":"].location == NSNotFound) {
        //找不到，则直接赋值
        return midle;
    }else{
        return [midle substringToIndex:[midle rangeOfString:@":"].location];
    }
}

@end
