//
//  LSCacheManager.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCacheManager : NSObject
/**
 单利方法
 @return return value
 */
+ (instancetype)sharedInstance ;

//缓存数据到指定的路径
- (void)archiverObject:(id)object ByKey:(NSString *)key WithPath:(NSString *)path;
//删除指定路径的缓存
- (void)removeObjectWithFilePath:(NSString *)path;
//根据缓存位置获取
+ (id)unarchiverObjectByKey:(NSString *)key WithPath:(NSString *)path;

@end
