//
//  NeedCareReportCellTableViewCell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/11/7.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface NeedCareReportCellTableViewCell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
