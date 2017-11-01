//
//  MDSickerDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSickerDetailModel : NSObject<YYModel>

@property (nonatomic , copy) NSString* username;
@property (nonatomic , assign) BOOL is_focus;
@property (nonatomic , copy) NSString* img_url;
@property (nonatomic , copy) NSString* sex;
@property (nonatomic , copy) NSString* remark;
@property (nonatomic , copy) NSString* birthday;
@property (nonatomic , copy) NSString* groups;
@property (nonatomic , copy) NSString* groupids;
@property (nonatomic , copy) NSString* classifyLabels;//自定义标签
@property (nonatomic , copy) NSDictionary* userLabels;//患者画像标签

@end
