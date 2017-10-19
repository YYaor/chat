//
//  MDRequestParameters.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
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
