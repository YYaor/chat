//
//  LSNetworkTool.h
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface LSNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)requestGetWithURL:(NSString *)url param:(id)param callBack:(void (^) (id))callBack;
- (void)requestPostWithURL:(NSString *)url param:(id)param callBack:(void (^) (id))callBack;

@end
