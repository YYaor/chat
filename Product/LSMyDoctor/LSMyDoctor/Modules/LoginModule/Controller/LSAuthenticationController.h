//
//  LSAuthenticationController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAuthenticationController : UIViewController

@property (nonatomic,strong)NSString* phoneNumStr;//手机号
@property (nonatomic,strong)NSString* verNumStr;//验证码
@property (nonatomic,strong)NSString* pwdStr;//密码

@end
