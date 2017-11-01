//
//  MDSickerGroupDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSickerGroupDetailModel : NSObject<YYModel>

@property (nonatomic ,copy) NSString* groupId;
@property (nonatomic ,copy) NSString* name;
@property (nonatomic ,copy) NSString* doctor_id;
@property (nonatomic ,copy) NSString* im_groupid;
@property (nonatomic ,copy) NSString* is_stick;
@property (nonatomic ,copy) NSArray* users;

@end

@interface MDSickerGroupUserModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic ,copy) NSString* im_username;
@property (nonatomic ,copy) NSString* user_id;
@property (nonatomic ,copy) NSString* username;
@property (nonatomic ,copy) NSString* type;

@end


