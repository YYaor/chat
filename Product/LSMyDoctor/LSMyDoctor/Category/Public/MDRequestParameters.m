//
//  MDRequestParameters.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDRequestParameters.h"

@implementation MDRequestParameters

+ (NSMutableDictionary*)shareRequestParameters
{
    //公共参数
    //登录后返回的cookie
    
    NSMutableDictionary *baseParameters = [[NSMutableDictionary alloc] init];
    if ([Defaults valueForKey:@"cookie"]) {
        
        [baseParameters setObject:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];//cookie
        
    }
    if ([Defaults valueForKey:@"accessToken"]) {
        
        [baseParameters setValue:AccessToken forKey:@"accessToken"];//token
    }
    
    return baseParameters;
    
}

@end
