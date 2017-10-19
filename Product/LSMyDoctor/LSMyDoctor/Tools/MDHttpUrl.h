//
//  MDHttpUrl.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#ifndef MDHttpUrl_h
#define MDHttpUrl_h

/**
 *   开发环境
 */
//#define API_HOST @"http://121.40.225.78:8080/youge-api/V2.0/dr"//开发环境

/**
 *   测试环境
 */
//#define API_HOST @"http://yg2test.369336699.com:8080/youge-api/V2.0"//测试环境


/**
 *   正式环境
 */
//#define API_HOST @"http://api.ug369.com/ug-api2/V2.0/dr"//正式环境

/**
 *   API_后台环境
 */
#define API_HOST @"http://39.108.12.48:8080/youge-api/V2.0/dr"//后台环境

//更新appURL
#define uploadNewAppUrl @"https://itunes.apple.com/cn/app/apple-store/id1123554194"

// 接口路径全拼
#define PATH(_path) [NSString stringWithFormat:_path, API_HOST]


#define UGAPI_HOST [API_HOST substringToIndex:API_HOST.length - 3]



#endif /* MDHttpUrl_h */
