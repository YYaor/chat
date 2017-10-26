//
//  MDChooseSickerModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDChooseSickerModel.h"

@implementation MDChooseSickerModel


//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDChooseSickerModel *sickerModel= [[MDChooseSickerModel allocWithZone:zone] init];
    
    sickerModel.birthday = [_birthday copy];
    sickerModel.sex = [_sex copy];
    sickerModel.username = [_username copy];
    sickerModel.is_focus = [_is_focus copy];
    sickerModel.user_id = [_user_id copy];
    sickerModel.is_Selected = _is_Selected;
    
    return sickerModel;
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
