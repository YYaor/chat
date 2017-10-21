//
//  MDDiscussListModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDDiscussListModel.h"

@implementation MDDiscussListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"groupId" : @"id"};
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
