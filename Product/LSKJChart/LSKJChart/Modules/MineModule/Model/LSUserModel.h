//
//  LSUserModel.h
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUserModel : NSObject

//头像链接
@property (nonatomic,strong)NSString *headImageURL;
//名称
@property (nonatomic,strong)NSString *name;
//医院
@property (nonatomic,strong)NSString *hospital;
//科室
@property (nonatomic,strong)NSString *room;
//职业
@property (nonatomic,strong)NSString *career;
//擅长
@property (nonatomic,strong)NSString *goodat;
//简介
@property (nonatomic,strong)NSString *info;

@end
