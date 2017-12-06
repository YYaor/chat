//
//  MDMyAdviceDetailModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDMyAdviceDetailModel.h"

@implementation MDMyAdviceDetailModel
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"advice_id" : @"id"};
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
