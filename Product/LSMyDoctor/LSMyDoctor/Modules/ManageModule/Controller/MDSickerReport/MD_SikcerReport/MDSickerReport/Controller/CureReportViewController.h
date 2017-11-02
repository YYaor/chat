//
//  CureReportViewController.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/14.
//
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"

@interface CureReportViewController : UIViewController

@property (nonatomic,assign) BOOL isHealthHistoryReport;//健康报告历史报告标识
@property (nonatomic,assign) BOOL isNotLoadReportData;//无须加载报告数据
@property (nonatomic,assign) BOOL isPopRootVC;//返回首页
@property(nonatomic,copy) NSString *reportTitleStr;
@property (nonatomic,copy) NSString *dateStr;

@property (nonatomic,assign) BOOL isHiddenDateLabel;
@property (nonatomic,assign) BOOL isDetailReport;
//@property (nonatomic,assign) BOOL isCopyReport;//是否问卷复制成功的报告

@property (nonatomic,copy) NSString *cycle;//报告周期类型:daily weekly monthly yearly detail 五项之一
@property (nonatomic,copy) NSString *searchKey;//报告搜索关键字
@property (nonatomic,assign) NSInteger date;//日期：YYYYmmdd
@property (nonatomic,copy) NSString *module;

@property (nonatomic , strong) NSString * detailKey;//T08报告标示符

@property (nonatomic,strong) ReportModel *reportModel;//报告数据模型
@property (nonatomic,copy) NSString *lifeDiaryDetailStr;//100 - 生活日记详版跳转标识符 200 - 雷达图跳转标识符

@property (nonatomic , strong) NSString * userIdStr;//患者iD


@property (nonatomic,strong) UIViewController *presentVC;//要跳转的控制器

@property (nonatomic,strong) NSMutableArray *itemsArray;

@property (nonatomic,copy) NSString *reportId;//特殊处理报告布局标识符
@property (nonatomic,copy) NSString *noDataReminderStr;

@end
