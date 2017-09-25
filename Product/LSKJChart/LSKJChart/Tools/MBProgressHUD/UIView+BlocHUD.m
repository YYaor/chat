//
//  UIView+BlocHUD.m
//  BlocSDK
//
//  Created by 刘博宇 on 2017/8/24.
//  Copyright © 2017年 Li. All rights reserved.
//

#import "UIView+BlocHUD.h"
#import "BlocMBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;


@implementation UIView (BlocHUD)

- (BlocMBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(BlocMBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)showRadioHUD{
    BlocMBProgressHUD *hud = [BlocMBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDRadio;
    [hud show:NO];
    [self setHUD:hud];
}

- (void)hideHUD{
    [[self HUD] hide:YES];
}


@end
