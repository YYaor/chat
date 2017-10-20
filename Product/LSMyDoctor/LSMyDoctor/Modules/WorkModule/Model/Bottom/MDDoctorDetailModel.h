//
//  MDDoctorDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDoctorDetailModel : NSObject<YYModel>

@property (nonatomic , strong) NSString* doctor_id;
@property (nonatomic , strong) NSString* doctor_name;
@property (nonatomic , strong) NSString* doctor_title;
@property (nonatomic , strong) NSString* doctor_image;
@property (nonatomic , strong) NSString* doctor_specialty;
@property (nonatomic , strong) NSString* doctor_phone;
@property (nonatomic , strong) NSString* doctor_introduction;
@property (nonatomic , strong) NSString* doctor_experience;
@property (nonatomic , strong) NSString* department_name;
@property (nonatomic , strong) NSString* hospital_name;
@property (nonatomic , strong) NSString* isFriend;

@end
