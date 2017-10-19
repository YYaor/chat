//
//  MDRequestParameters.h
//  MyDoctor
//
//  Created by 惠生 on 17/5/23.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDRequestParameters : NSObject

#warning 只有登录成功后才可以使用，登录之前，后台不会返回cookie

/**
 *  公共报文部分参数
 *
 *  @param busCode 业务代码，映射方法名
 *
 *  @return 公共报文
 */

+ (NSMutableDictionary*)shareRequestParameters;

@end
