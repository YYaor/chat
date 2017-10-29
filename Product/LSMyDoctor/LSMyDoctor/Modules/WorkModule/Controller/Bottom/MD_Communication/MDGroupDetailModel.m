//
//  MDGroupDetailModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDGroupDetailModel.h"

@implementation MDGroupDetailModel


//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDGroupDetailModel *groupDetailModel = [[MDGroupDetailModel allocWithZone:zone] init];
    
    groupDetailModel.name = [_name copy];
    groupDetailModel.doctor_id = [_doctor_id copy];
    groupDetailModel.im_roomid = [_im_roomid copy];
    
    //群用户数据
    NSMutableArray* arr = [NSMutableArray array];
    for (MDGroupUserModel* userModel in _users) {
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
    return @{@"users":[MDGroupUserModel class]};
    
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

@implementation MDGroupUserModel

//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDGroupUserModel *groupUserModel = [[MDGroupUserModel allocWithZone:zone] init];
    
    groupUserModel.im_username = [_im_username copy];
    groupUserModel.doctor_id = [_doctor_id copy];
    groupUserModel.doctor_name = [_doctor_name copy];
    groupUserModel.doctor_title = [_doctor_title copy];
    groupUserModel.doctor_phone = [_doctor_phone copy];
    groupUserModel.department_name = [_department_name copy];
    groupUserModel.hospital_name = [_hospital_name copy];
    
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



