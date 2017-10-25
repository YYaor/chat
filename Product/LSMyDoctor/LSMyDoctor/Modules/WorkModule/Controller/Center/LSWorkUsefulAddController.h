//
//  LSWorkUsefulAddController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWorkUsefulAddController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, copy) void (^addBlock)(NSDictionary *dataDic) ;

@property (nonatomic, copy) void (^updateBlock)(NSDictionary *dataDic) ;

@property (nonatomic, copy) void (^deleteBlock)(NSDictionary *dataDic) ;


@end
