//
//  T09Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 17/1/12.
//
//

#import <UIKit/UIKit.h>

@interface T09Cell : UITableViewCell

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@property (nonatomic,strong) UIViewController *vc;
@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
