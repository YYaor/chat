//
//  LSChoosePatientController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/9.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSChoosePatientController : UIViewController

@property (nonatomic,copy)void (^chooseBlock)(NSArray *modelArray);


@end
