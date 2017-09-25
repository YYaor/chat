//
//  LSNetworkTool.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSNetworkTool.h"

@implementation LSNetworkTool

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        instance = [[self alloc] initWithBaseURL:nil];
    });
    return instance;
}

- (void)requestGetWithURL:(NSString *)url param:(id)param callBack:(void (^) (id))callBack
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", LSBASEURL, url];
    
    [self GET:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        callBack(responseObject);
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        callBack(error);
    }];
}

- (void)requestPostWithURL:(NSString *)url param:(id)param callBack:(void (^) (id))callBack
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", LSBASEURL, url];
    
    [self POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         callBack(responseObject);
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         callBack(error);
     }];
}

@end
