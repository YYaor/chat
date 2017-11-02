//
//  T16Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/14.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface T16Cell : UITableViewCell

@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic,assign) NSInteger stepCount;//步进值
@property (nonatomic,strong) NSIndexPath *path;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
//- (void)configUI:(NSIndexPath *)indexPath Lines:(NSInteger )lines StepCount:(NSInteger)stepcount;

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
