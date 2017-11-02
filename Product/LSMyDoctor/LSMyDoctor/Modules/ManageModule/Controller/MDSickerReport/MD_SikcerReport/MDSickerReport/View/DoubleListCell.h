//
//  DoubleListCell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/29.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface DoubleListCell : UITableViewCell

@property (nonatomic,copy) NSDictionary *dict;

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
