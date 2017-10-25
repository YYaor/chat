//
//  LSMineModel.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSMineModel : NSObject

@property (nonatomic, copy) NSString *myName;
@property (nonatomic, copy) NSString *customerService;
@property (nonatomic, copy) NSString *myRemark;
@property (nonatomic, copy) NSString *myQR;
@property (nonatomic, copy) NSString *im_username;
@property (nonatomic, copy) NSString *myBackgroud;
@property (nonatomic, copy) NSString *myImage;

@property (nonatomic, copy) NSArray *myServiceCount;
@property (nonatomic, copy) NSArray *myBaseInfo;
@property (nonatomic, copy) NSArray *myServices;

@end
