//
//  MDDoctorDetailEvaluateModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/6.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDoctorDetailEvaluateModel : NSObject<YYModel>

@property (nonatomic , strong) NSString* score;
@property (nonatomic , strong) NSString* content;
@property (nonatomic , strong) NSString* symptom;
@property (nonatomic , strong) NSString* createTime;
@property (nonatomic , strong) NSString* name;

@end
