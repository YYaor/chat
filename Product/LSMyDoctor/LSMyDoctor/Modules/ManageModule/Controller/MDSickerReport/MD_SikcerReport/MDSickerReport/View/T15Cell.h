//
//  T15Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface T15Cell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,assign) BOOL isSetXStepArray;//是否设置步进值数组
@property (nonatomic,assign) BOOL isYearReport;//是否是年报
@property (nonatomic,assign) BOOL isMonthReport;//是否是年报

@property (nonatomic,assign) NSInteger stepCount;//步进值
@property (nonatomic,strong) NSIndexPath *path;


@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) ReportControlModel *control;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
