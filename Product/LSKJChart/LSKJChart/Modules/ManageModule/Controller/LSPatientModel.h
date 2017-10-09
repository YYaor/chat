//
//  LSPatientModel.h
//  LSKJChart
//
//  Created by 刘博宇 on 2017/10/9.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPatientModel : NSObject

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *sex;

@property (nonatomic,strong)NSString *age;

@property (nonatomic,assign)BOOL isChoosed;

@end
