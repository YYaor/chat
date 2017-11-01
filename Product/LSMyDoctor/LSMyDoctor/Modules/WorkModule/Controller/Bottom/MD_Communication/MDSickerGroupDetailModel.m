//
//  MDSickerGroupDetailModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerGroupDetailModel.h"

@implementation MDSickerGroupDetailModel
//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDSickerGroupDetailModel *groupDetailModel = [[MDSickerGroupDetailModel allocWithZone:zone] init];
    
    groupDetailModel.name = [_name copy];
    groupDetailModel.doctor_id = [_doctor_id copy];
    groupDetailModel.im_groupid = [_im_groupid copy];
    groupDetailModel.is_stick = [_is_stick copy];
    
    //群用户数据
    NSMutableArray* arr = [NSMutableArray array];
    for (MDSickerGroupUserModel* userModel in _users) {
        [arr addObject:[userModel copy]];
    }
    groupDetailModel.users = [arr copy];
    
    return groupDetailModel;
}
//第二级content
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"groupId" : @"id" };
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"users":[MDSickerGroupUserModel class]};
    
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
@implementation MDSickerGroupUserModel

//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDSickerGroupUserModel *groupUserModel = [[MDSickerGroupUserModel allocWithZone:zone] init];
    
    groupUserModel.im_username = [_im_username copy];
    groupUserModel.user_id = [_user_id copy];
    groupUserModel.username = [_username copy];
    groupUserModel.type = [_type copy];
    
    return groupUserModel;
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


