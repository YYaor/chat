//
//  T24Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface T24Cell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调
@property (nonatomic,strong)ReportItemDataModel *dataModel;
@end
