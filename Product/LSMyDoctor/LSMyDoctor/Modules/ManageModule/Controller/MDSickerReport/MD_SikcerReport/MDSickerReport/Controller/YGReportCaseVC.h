//
//  YGReportCaseVC.h
//  YouGeHealth
//
//  Created by 惠生 on 17/1/16.
//
//

#import <UIKit/UIKit.h>

@interface YGReportCaseVC : UIViewController


@property(nonatomic, strong) NSString* applayoutCode;
@property(nonatomic, strong) NSString* timeStr;//上方显示时间
@property (nonatomic,assign) NSInteger qnCodeNum;//对应的qnCode
@property(nonatomic, strong) NSString* userIdStr;//用户ID

@end
