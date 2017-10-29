//
//  MDGroupDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDGroupDetailModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic ,copy) NSString* groupId;
@property (nonatomic ,copy) NSString* name;
@property (nonatomic ,copy) NSString* doctor_id;
@property (nonatomic ,copy) NSString* im_roomid;
@property (nonatomic ,copy) NSArray* users;

@end

@interface MDGroupUserModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic ,copy) NSString* im_username;
@property (nonatomic ,copy) NSString* doctor_id;
@property (nonatomic ,copy) NSString* doctor_name;
@property (nonatomic ,copy) NSString* doctor_title;
@property (nonatomic ,copy) NSString* doctor_phone;
@property (nonatomic ,copy) NSString* department_name;
@property (nonatomic ,copy) NSString* hospital_name;

@end


