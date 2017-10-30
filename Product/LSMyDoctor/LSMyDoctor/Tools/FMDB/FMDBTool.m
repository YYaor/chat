//
//  FMDBTool.m
//  nq
//
//  Created by whlpp on 15/12/24.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import "FMDBTool.h"
#import "FMDataBase.h"

@implementation FMDBTool

#define DB_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userInfo.db"]

#pragma mark
#pragma mark -  create

+ (void)createTypeListTableWithTyoeListName:(NSString *)typeListName
                                       type:(NSDictionary *)type {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        //typeList 创建的表名
        NSMutableString *sqlCreateTable = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", typeListName];
//        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS typeList (typeName text, typeImage text, typeImageName text)"];//string 为 text
        NSMutableArray *types = [[NSMutableArray alloc] init];
        [type enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString *typeString = [NSString stringWithFormat:@"%@ %@", key, obj];
            [types addObject:typeString];
        }];
        if (types.count > 0) {
            
            [sqlCreateTable appendString:[types componentsJoinedByString:@", "]];
        }
        [sqlCreateTable appendString:@")"];
        [db executeUpdate:sqlCreateTable];
        [db close];
    }
}

#pragma mark
#pragma mark -  insert

+ (void)insertTypeListToSqlTableWithTypeListName:(NSString *)typeListName
                                            data:(NSDictionary *)data {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        if (data && data.allKeys.count > 0) {
            
            NSMutableString *sqlString = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", typeListName];
            NSMutableArray *object = [[NSMutableArray alloc] init];
            NSMutableArray *keys = [[NSMutableArray alloc] init];
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [object addObject:[NSString stringWithFormat:@"'%@'", obj]];
                [keys addObject:key];
            }];
            //@"INSERT INTO typeList (typeName, typeImage, typeImageName) VALUES (?,?,?)", typeName, typeImage, typeImageName
            [sqlString appendFormat:@"(%@) VALUES (%@)", [keys componentsJoinedByString:@", "], [object componentsJoinedByString:@", "]];
            [db executeUpdate:sqlString];
            [db close];
        }
    }
}

+ (void)insertReferContentToSqlTableWithTypeListName:(NSString *)typeListName
                                        typeListType:(NSDictionary *)typeListType
                                      referCondition:(NSString *)referCondition
                                           referData:(NSArray *)referData {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    
    if ([db open]) {
        
        if (referData.count > 0) {
            
            NSMutableArray *keys = [[typeListType allKeys] mutableCopy];
            NSArray *oldData = [FMDBTool selectReferOldContentToSqlTableWithTypeListName:typeListName referCondition:referCondition];
            NSInteger sortID = oldData.count + 1;
            for (NSDictionary *dic in referData) {
                
                NSMutableString *sqlString = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", typeListName];
                
                NSString *newRefer = dic[referCondition];
                if (oldData.count > 0) {
                    
                    NSInteger count = 0;
                    for (NSString *referString in oldData) {
                        
                        if ([newRefer isEqualToString:referString]) continue;
                        count ++;
                    }
                    
                    if (count == oldData.count) {
                        
                        NSMutableArray *object = [@[] mutableCopy];
                        for (NSString *key in keys) {
                            
                            [object addObject:[NSString stringWithFormat:@"'%@'", dic[key]]];
                        }
                        
                        [sqlString appendFormat:@"(%@) VALUES (%@)", [keys componentsJoinedByString:@", "], [object componentsJoinedByString:@", "]];
                        [db executeUpdate:sqlString];
                        
                        sortID ++;
                    }
                    
                } else {
                    
                    NSMutableArray *object = [@[] mutableCopy];
                    for (NSString *key in keys) {
                        
                    [object addObject:[NSString stringWithFormat:@"'%@'", dic[key]]];
                    }
                    
                    [sqlString appendFormat:@"(%@) VALUES (%@)", [keys componentsJoinedByString:@", "], [object componentsJoinedByString:@", "]];
                    [db executeUpdate:sqlString];
                    
                    sortID ++;
                }
            }
        }
        
        [db close];
    }
}

#pragma mark
#pragma mark -  select

+ (NSDictionary *)selectUserLoginViewInfoSqlTable {
    
    NSDictionary *dic = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    
    if ([db open]) {
        
        //查询
        FMResultSet *result = [db executeQuery:@"SELECT * FROM typeList"];
        while ([result next]) {
            
            NSString *name      = [result stringForColumn:@"name"];
            NSString *typeImage = [result stringForColumn:@"typeImage"];
            NSString *typeImageName = [result stringForColumn:@"typeImageName"];
            dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", typeImage, @"typeImage", typeImageName, @"typeImageName", nil];
        }
        
        [db close];
    }
    
    return dic;
}

+ (NSDictionary *)selectUserLoginViewInfoSqlTableWithTypeListName:(NSString *)typeListName
                                                           search:(NSArray *)search
                                                         dataTyep:(NSDictionary *)dataType {
    
    NSMutableDictionary *dic = nil;
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    
    if ([db open]) {
        
        //查询
        NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@", typeListName];
        if (search && search.count > 0) {
            
            NSString *appString = [search componentsJoinedByString:@" and "];
            [sqlString appendFormat:@" WHERE %@", appString];
        }
        FMResultSet *result = [db executeQuery:sqlString];
        while ([result next]) {
            
            dic = [[NSMutableDictionary alloc] init];
            for (NSString *key in dataType) {
                
                if ([dataType[key] isEqualToString:@"text"]) {
                    
                    NSString *string = [result stringForColumn:key];
                    [dic setObject:string ? string : @"" forKey:key];
                }
                else if ([dataType[key] isEqualToString:@"integer"]) {
                    
                    [dic setObject:@([result intForColumn:key]) forKey:key];
                }
                else if ([dataType[key] isEqualToString:@"real"]) {
                    
                    [dic setObject:@([result doubleForColumn:key]) forKey:key];
                }
            }
            [db close];
            return dic;
        }
    }
    [db close];
    return dic;
}

+ (void)selectUserLoginViewInfoSqlTableWithTypeListName:(NSString *)typeListName
                                               dataTyep:(NSDictionary *)dataType
                                                  block:(void(^)(NSArray *datas))block {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("MyThreadQueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
        
        if ([db open]) {
            
            //查询
            NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@", typeListName];
            FMResultSet *result = [db executeQuery:sqlString];
            while ([result next]) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                for (NSString *key in dataType) {
                    
                    if ([dataType[key] isEqualToString:@"text"]) {
                        
                        NSString *string = [result stringForColumn:key];
                        [dic setObject:string ? string : @"" forKey:key];
                    }
                    else if ([dataType[key] isEqualToString:@"integer"]) {
                        
                        [dic setObject:@([result intForColumn:key]) forKey:key];
                    }
                    else if ([dataType[key] isEqualToString:@"real"]) {
                        
                        [dic setObject:@([result doubleForColumn:key]) forKey:key];
                    }
                }
                [data addObject:dic];
            }
            [db close];
            if (block) {
                
                block(data);
            }
        }
    });
}

#pragma mark -  Refer
+ (NSArray *)selectTypeListContentToSqlTableWithTypeListName:(NSString *)typeListName
                                                typeListType:(NSDictionary *)typeListType {
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    
    if ([db open]) {
        
        //查询
        NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@", typeListName];
        NSArray *keys = [typeListType allKeys];
        
        FMResultSet *result = [db executeQuery:sqlString];
        while ([result next]) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in keys) {
                
                NSString *string = [result stringForColumn:key];
                if (!string) {
                    string = @"";
                }
                [dic setObject:string forKey:key];
            }
         
            [data addObject:dic];
        }
        [db close];
    }
    return data;
}

+ (NSArray *)selectReferOldContentToSqlTableWithTypeListName:(NSString *)typeListName
                                              referCondition:(NSString *)referCondition {
    
    NSMutableArray *referStrings = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    
    if ([db open]) {
        
        //查询
        NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM %@", typeListName];
        FMResultSet *result = [db executeQuery:sqlString];
        while ([result next]) {
            
            NSString *referString = [result stringForColumn:referCondition];
            
            [referStrings addObject:referString];
        }
        [db close];
    }
    return referStrings;
}

+ (BOOL)typeListWithTypeListName:(NSString *)typeListName {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", typeListName]];
        [db close];
        if (result) {
            
            return YES;
        }
        else {
            
            return NO;
        }
    }
    return NO;
}

#pragma mark
#pragma mark -  updata
+ (void)updataTypeInfoSqltWithTypeListName:(NSString *)typeListName
                                       key:(NSString *)key
                                updateData:(NSDictionary *)updateData {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open] && updateData.allKeys.count > 0) {
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [updateData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [data addObject:[NSString stringWithFormat:@"%@ = '%@'", key, obj]];
        }];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", typeListName, [data componentsJoinedByString:@", "] , key]];
        [db close];
    }
}

+ (void)updataIsSubscibeToSqlWithTypeListName:(NSString *)typeListName
                              changeAttribute:(NSString *)changeAttribute
                                    newString:(NSString *)newString
                               referCondition:(NSString *)referCondition
                              conditionString:(NSString *)conditionString {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        if (referCondition.length > 0) {
            
            NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", typeListName, changeAttribute, referCondition];
            [db executeUpdate:sqlString, newString, conditionString];
        }
        [db close];
    }
}

#pragma mark
#pragma mark - remove
/**
 *  删除
 *
 *  @param contentAddDateDifferValue <#contentAddDateDifferValue description#>
 */
+ (void)removeSql:(NSString *)contentAddDateDifferValue {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:@"delete from typeList where contentAddDateDifferValue = ?"];
        [db executeUpdate:deleteSql, contentAddDateDifferValue];
        
        [db close];
    }
}

+ (void)removeOneTableContentToSqlWithTypeListName:(NSString *)typeListName {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:@"delete from '%@'", typeListName];
        
        [db executeUpdate:deleteSql];
        
        [db close];
    }
}

+ (void)removeTypeListOneDataToSqlWithTypeListName:(NSString *)typeListName
                                    referCondition:(NSString *)referCondition {
    
    FMDatabase *db = [FMDatabase databaseWithPath:DB_PATH];
    if ([db open]) {
        
        NSMutableString *deleteSql = [NSMutableString stringWithFormat:@"delete from '%@'", typeListName];
        
        if (referCondition) {
            
            [deleteSql appendFormat:@" where = %@", referCondition];
        }
        
        [db executeUpdate:deleteSql];
        
        [db close];
    }
}

@end
