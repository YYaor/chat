//
//  DietReportVC.h
//  YouGeHealth
//
//  Created by yunzujia on 16/10/26.
//
//

#import <UIKit/UIKit.h>
#import "DietReportModel.h"
@interface DietReportVC : UIViewController

@property (nonatomic, strong) NSDate * foodDate;
@property (nonatomic,copy) NSString *cycle;//报告周期类型:daily weekly monthly yearly detail 五项之一
@property (nonatomic,assign) NSInteger date;//日期：YYYYmmdd
@property (nonatomic,copy) NSString *module;
@property (strong,nonatomic) NSMutableArray<DRGItemModel*> *dataArray;

@property (nonatomic , strong) NSString* qnCode;//2代表生活日记简单版跳转

@end
