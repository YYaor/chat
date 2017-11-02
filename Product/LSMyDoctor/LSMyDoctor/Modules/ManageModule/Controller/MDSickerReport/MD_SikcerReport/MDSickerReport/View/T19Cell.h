//
//  T19Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/15.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface T19Cell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@property (nonatomic,assign) NSInteger stepCount;//步进值
@property (nonatomic,strong) NSIndexPath *path;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@end
