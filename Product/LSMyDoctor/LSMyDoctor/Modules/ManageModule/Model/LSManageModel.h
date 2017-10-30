//
//  LSManageModel.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSManageModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *birthday;//患者出生日期
@property (nonatomic, copy) NSString *img_url;//患者头像
@property (nonatomic, copy) NSString *is_focus;//是否关注 0否 1是
@property (nonatomic, copy) NSString *sex;//患者性别
@property (nonatomic, copy) NSString *user_id;//患者ID
@property (nonatomic, copy) NSString *username;//患者姓名

@end
