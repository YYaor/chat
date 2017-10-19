//
//  MDRequestParameters.m
//  MyDoctor
//
//  Created by 惠生 on 17/5/23.
//  Copyright © 2017年 惠生. All rights reserved.
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
        
        [baseParameters setObject:AccessToken forKey:@"accessToken"];//token
    }
    
    return baseParameters;
    
}

@end
