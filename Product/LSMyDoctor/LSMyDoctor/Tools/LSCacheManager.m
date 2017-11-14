//
//  LSCacheManager.m
//  LSMyDoctor
//
//  Created by 刘博宇 on 2017/11/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSCacheManager.h"

@implementation LSCacheManager

+ (instancetype)sharedInstance
{
    static LSCacheManager *instance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LSCacheManager alloc] init];
    });
    return instance ;
}

- (void)archiverObject:(id)object ByKey:(NSString *)key WithPath:(NSString *)path
{
    //初始化存储对象信息的data
    NSMutableData *data = [NSMutableData data];
    //创建归档工具对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //开始归档
    [archiver encodeObject:object forKey:key];
    //结束归档
    [archiver finishEncoding];
    //写入本地
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *destPath = [[docPath stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:path];
    
    [data writeToFile:destPath atomically:YES];
}

- (void)removeObjectWithFilePath:(NSString *)path{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *destPath = [[docPath stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:path];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:destPath]) {
        [defaultManager removeItemAtPath:destPath error:nil];
    }
}

+ (id)unarchiverObjectByKey:(NSString *)key WithPath:(NSString *)path
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *destPath = [[docPath stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:path];
    NSData *data = [NSData dataWithContentsOfFile:destPath];
    //创建反归档对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //接收反归档得到的对象
    id object = [unarchiver decodeObjectForKey:key];
    return object;
}

@end
