//
//  LSMineUserSettingController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSMineModel.h"

@interface LSMineUserSettingController : UIViewController

@property (nonatomic, strong) LSMineModel *model;

- (void)updateMainInfoData;

@end
