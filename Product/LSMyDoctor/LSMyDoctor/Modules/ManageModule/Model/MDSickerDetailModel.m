//
//  MDSickerDetailModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerDetailModel.h"

@implementation MDSickerDetailModel
//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDSickerDetailModel *detailModel= [[MDSickerDetailModel allocWithZone:zone] init];
    
    detailModel.username = [_username copy];
    detailModel.is_focus = _is_focus;
    detailModel.sex = [_sex copy];
    detailModel.birthday = [_birthday copy];
    detailModel.groups = [_groups copy];
    detailModel.classifyLabels = [_classifyLabels copy];
    
    detailModel.userLabels = [_userLabels copy];
    
    return detailModel;
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
