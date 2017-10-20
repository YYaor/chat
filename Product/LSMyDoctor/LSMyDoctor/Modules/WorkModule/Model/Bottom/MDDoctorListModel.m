//
//  MDDoctorListModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDDoctorListModel.h"

@implementation MDDoctorListModel

//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDDoctorListModel *docotorListModel= [[MDDoctorListModel allocWithZone:zone] init];
    
    docotorListModel.department_name = [_department_name copy];
    docotorListModel.doctor_experience = [_doctor_experience copy];
    docotorListModel.doctor_id = [_doctor_id copy];
    docotorListModel.doctor_image = [_doctor_image copy];
    docotorListModel.doctor_introduction = [_doctor_introduction copy];
    docotorListModel.doctor_name = [_doctor_name copy];
    docotorListModel.doctor_phone = [_doctor_phone copy];
    docotorListModel.doctor_specialty = [_doctor_specialty copy];
    docotorListModel.doctor_title = [_doctor_title copy];
    docotorListModel.hospital_name = [_hospital_name copy];
    docotorListModel.isFriend = _isFriend;
    docotorListModel.is_focus = _is_focus;
    
    return docotorListModel;
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
