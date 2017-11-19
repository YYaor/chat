//
//  YGMedicalRecordDetailModel.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/13.
//
//

#import "YGMedicalRecordDetailModel.h"

@implementation YGMedicalRecordDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"checke_imgs":[YGMedicalRecordImgModel class],@"pharmacy_imgs":[YGMedicalRecordImgModel class]};
}
//第二级content
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"record_id" : @"id"};
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

@implementation YGMedicalRecordImgModel

@end



