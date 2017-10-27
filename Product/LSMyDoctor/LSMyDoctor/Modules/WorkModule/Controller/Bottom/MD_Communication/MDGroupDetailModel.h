//
//  MDGroupDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDGroupDetailModel : NSObject<YYModel>

@property (nonatomic ,strong) NSString* groupId;
@property (nonatomic ,strong) NSString* name;
@property (nonatomic ,strong) NSString* doctor_id;
@property (nonatomic ,strong) NSString* im_roomid;
@property (nonatomic ,strong) NSArray* users;

@end

@interface MDGroupUserModel : NSObject<YYModel>

@property (nonatomic ,strong) NSString* im_username;
@property (nonatomic ,strong) NSString* doctor_id;
@property (nonatomic ,strong) NSString* doctor_name;
@property (nonatomic ,strong) NSString* doctor_title;
@property (nonatomic ,strong) NSString* doctor_phone;
@property (nonatomic ,strong) NSString* department_name;
@property (nonatomic ,strong) NSString* hospital_name;

@end


