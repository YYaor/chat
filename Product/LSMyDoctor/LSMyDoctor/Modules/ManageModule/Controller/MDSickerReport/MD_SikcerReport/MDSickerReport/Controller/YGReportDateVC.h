//
//  YGReportDateVC.h
//  YouGeHealth
//
//  Created by 惠生 on 17/1/13.
//
//

#import <UIKit/UIKit.h>

@interface YGReportDateVC : UIViewController

@property (nonatomic,assign) NSInteger qnCodeNum;//对应的qnCode
@property(nonatomic , strong) NSString* applayoutCode;//模块code

@property(nonatomic , strong) NSString* titleStr;//模块code

@property (nonatomic,copy) NSString *module;
@property (nonatomic,assign) NSInteger date;//日期：YYYYmmdd

@property(nonatomic , strong) NSString* userIdStr;//用户iD

@end
