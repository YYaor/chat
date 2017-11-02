//
//  YGSportCell.h
//  YouGeHealth
//
//  Created by 王全江 on 16/11/2.
//
//

#import <UIKit/UIKit.h>
#import "WFHelperButton.h"

@protocol YGSportCellDelegate <NSObject>

- (void)yGSportCellDetailBtnClickWithButton:(WFHelperButton *)sender;//下方按钮传值方法

@end

@interface YGSportCell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic,copy) NSArray *mutArr;

@property (nonatomic , strong) NSString * timeStr;//时间框
@property (nonatomic,assign) NSInteger dateStr;//日期：YYYYmmdd
@property (nonatomic , strong) NSString * moduleStr;//标示符


//代理方法
@property (strong,nonatomic) id<YGSportCellDelegate>delegate;//点击下方按钮传值

@end
