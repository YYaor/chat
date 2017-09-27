//
//  LSUtil.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSUtil.h"

@implementation LSUtil

+(void)showAlter:(UIView *)view withText:(NSString *)text withOffset:(float)offset{
    if(view == nil){
        return;
    }
//    BlocMBProgressHUD *HUD = [BlocMBProgressHUD showHUDAddedTo:view animated:YES];
    BlocMBProgressHUD *HUD = [BlocMBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.color = nil;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = text;
    HUD.margin = 10.f;
    HUD.yOffset = offset;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:2];
}

@end
