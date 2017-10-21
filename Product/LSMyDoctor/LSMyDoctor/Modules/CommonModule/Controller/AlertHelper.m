//
//  AlertHelper.m
//  YouGeHealth
//
//  Created by zj on 16/9/7.
//
//

#import "AlertHelper.h"

@implementation AlertHelper


+(void)InitMyAlertMessage:(NSString *)title And:(UIViewController *)mycontroller
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: @""
                                                                    message: title
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.view.tintColor = RGBCOLOR(65, 208, 105);
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@""];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:23]
                  range:NSMakeRange(0, 0)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, title.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消的按钮");
        
    }]];
    
    [mycontroller presentViewController:alert animated:YES completion:nil];
}

+(void)InitMyAlertWithTile:(NSString *) title Message:(NSString *)message And:(UIViewController *)mycontroller
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.view.tintColor = RGBCOLOR(65, 208, 105);
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@""];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:23]
                  range:NSMakeRange(0, 0)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, message.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消的按钮");
        
    }]];
    
    [mycontroller presentViewController:alert animated:YES completion:nil];
}

+(void)InitMyAlertWithMessageAndBlock:(NSString *)title And:(UIViewController *)mycontroller AndCallback:(MutableBlock)callback
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: @""
                                                                    message: title
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.view.tintColor = RGBCOLOR(65, 208, 105);
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@""];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:23]
                  range:NSMakeRange(0, 0)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, title.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      
        callback(@"hahaah 回调干的事");
        
    }]];
    
    [mycontroller presentViewController:alert animated:YES completion:nil];
}

+(void)InitMyAlertWithTitle:(NSString *) title AndMessage:(NSString *)message  And:(UIViewController *)mycontroller btnName:(NSString *)btnName AndCallback:(MutableBlock)callback
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.view.tintColor = RGBCOLOR(65, 208, 105);
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:23]
                  range:NSMakeRange(0, 0)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, message.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:btnName style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        callback(@"hahaah 回调干的事");
        
    }]];
    
    [mycontroller presentViewController:alert animated:YES completion:nil];
}

+(void)InitMyAlertWithTitle:(NSString *) title AndMessage:(NSString *)message  And:(UIViewController *)mycontroller CanCleBtnName:(NSString *)CancleBtnName SureBtnName:(NSString *)SureBtnName AndCancleBtnCallback:(MutableBlock)cancleCallback AndSureBtnCallback:(MutableBlock)sureCallback
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.view.tintColor = RGBCOLOR(65, 208, 105);
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:20]
                  range:NSMakeRange(0, 0)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, message.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [alert addAction:[UIAlertAction actionWithTitle:CancleBtnName style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancleCallback(@"hahaah 回调干的事");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:SureBtnName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        sureCallback(@"hahaah 回调干的事");
        
    }]];
    
    [mycontroller presentViewController:alert animated:YES completion:nil];
}

@end
