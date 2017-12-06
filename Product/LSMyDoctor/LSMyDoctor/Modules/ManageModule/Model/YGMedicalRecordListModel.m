//
//  YGMedicalRecordListModel.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/9.
//
//

#import "YGMedicalRecordListModel.h"

@implementation YGMedicalRecordListModel
//第二级content
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"recordId" : @"id"};
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
