//
//  AlertHelper.h
//  YouGeHealth
//
//  Created by zj on 16/9/7.
//
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject<UIAlertViewDelegate>

+(void)InitMyAlertMessage:(NSString *)title And:(UIViewController *)myview;
+(void)InitMyAlertWithTile:(NSString *) title Message:(NSString *)message And:(UIViewController *)mycontroller;

+(void)InitMyAlertWithMessageAndBlock:(NSString *)title And:(UIViewController *)myview AndCallback:(MutableBlock)callback;
+(void)InitMyAlertWithTitle:(NSString *) title AndMessage:(NSString *)message  And:(UIViewController *)mycontroller btnName:(NSString *)btnName AndCallback:(MutableBlock)callback;
//带取消按钮
+(void)InitMyAlertWithTitle:(NSString *) title AndMessage:(NSString *)message  And:(UIViewController *)mycontroller CanCleBtnName:(NSString *)CancleBtnName SureBtnName:(NSString *)SureBtnName AndCancleBtnCallback:(MutableBlock)cancleCallback AndSureBtnCallback:(MutableBlock)sureCallback;

@end
