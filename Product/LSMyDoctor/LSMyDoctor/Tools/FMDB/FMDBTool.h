//
//  FMDBTool.h
//  nq
//
//  Created by whlpp on 15/12/24.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBTool : NSObject

/**
 *  查询表是否存在
 *
 *  @param typeListName 表名
 *
 *  @return 是否存在该表
 */
+ (BOOL)typeListWithTypeListName:(NSString *)typeListName;


#pragma mark -  create
/**
 *  创建表 表名，表元素
 *  @param typeListName 表名
 *  @param type 表元素 key 为 元素名称 obj 为元素类型
 */
+ (void)createTypeListTableWithTyoeListName:(NSString *)typeListName
                                       type:(NSDictionary *)type;


#pragma mark -  insert
/**
 *  添加表内容
 *
 *  @param typeListName 表名
 *  @param typeListType 数据类型 referCondition 为筛选条件  referData 请求下来的数据
 */
+ (void)insertReferContentToSqlTableWithTypeListName:(NSString *)typeListName
                                        typeListType:(NSDictionary *)typeListType
                                      referCondition:(NSString *)referCondition
                                           referData:(NSArray *)referData;
/**
 *  添加一条数据
 *
 *  @param typeListName 表名
 *  @param data         数据
 */
+ (void)insertTypeListToSqlTableWithTypeListName:(NSString *)typeListName
                                            data:(NSDictionary *)data;

#pragma mark -  select
/**
 *  查询表内容
 *
 *  @param typeListName 表名
 *  @param search       sql搜索语句
 *  @param dataType     数据类型
 *
 *  @return 查询出的数据，如果nil，则没有这条数据
 */
+ (NSDictionary *)selectUserLoginViewInfoSqlTableWithTypeListName:(NSString *)typeListName
                                                           search:(NSArray *)search
                                                         dataTyep:(NSDictionary *)dataType;
/**
 *  查询内容
 *
 *  @param typeListName 表名
 *  @param typeListType 数据类型
 */
+ (NSArray *)selectTypeListContentToSqlTableWithTypeListName:(NSString *)typeListName
                                                typeListType:(NSDictionary *)typeListType;

/**
 *  查询表里所有内容
 *
 *  @param typeListName 表名
 *  @param dataType     数据类型
 *  @param block        查询回调
 */
+ (void)selectUserLoginViewInfoSqlTableWithTypeListName:(NSString *)typeListName
                                               dataTyep:(NSDictionary *)dataType
                                                  block:(void(^)(NSArray *datas))block;


#pragma mark -  updata
/**
 *  修改数据
 *
 *  @param typeListName 表名
 *  @param key          主键
 *  @param updateData   更新的数据
 */
+ (void)updataTypeInfoSqltWithTypeListName:(NSString *)typeListName
                                       key:(NSString *)key
                                updateData:(NSDictionary *)updateData;

/**
 *  修改单条数据
 *
 *  @param typeListName         表名
 *  @param changeAttribute      要修改的属性
 *  @param newString            新的数据
 *  @param referCondition       做判断的属性
 *  @param conditionString      参照条件
 */
+ (void)updataIsSubscibeToSqlWithTypeListName:(NSString *)typeListName
                              changeAttribute:(NSString *)changeAttribute
                                    newString:(NSString *)newString
                               referCondition:(NSString *)referCondition
                              conditionString:(NSString *)conditionString;

#pragma mark -  remove
/**
 *  删除表
 *
 *  @param typeListName 表名
 */
+ (void)removeOneTableContentToSqlWithTypeListName:(NSString *)typeListName;

/**
 *  删除表中一条数据
 *
 *  @param typeListName    表名
 *  @param referCondition  判断条件
 *  @param removeCondition 以此为删除条件
 */
+ (void)removeTypeListOneDataToSqlWithTypeListName:(NSString *)typeListName
                                    referCondition:(NSString *)referCondition;

@end
