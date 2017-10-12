//
//  LSUtil.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LSUtil : NSObject

//获取排序后的字典和key 从A到Z
typedef void(^PatientListDictBlock)(NSDictionary<NSString *,NSMutableDictionary *> *addressBookDict,NSArray *nameKeys);

//Toast提示文案
+(void)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset;


//传入患者数组 按字母顺序返回
+ (void)getOrderPatientList:(NSArray *)patientList patientListDictBlock:(PatientListDictBlock)patientListInfo;

@end
