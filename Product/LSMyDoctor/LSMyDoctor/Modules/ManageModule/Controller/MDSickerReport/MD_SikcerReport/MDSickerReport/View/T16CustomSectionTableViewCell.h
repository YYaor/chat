//
//  T16CustomSectionTableViewCell.h
//  YouGeHealth
//
//  Created by MagicBeans2 on 17/1/22.
//
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@interface T16CustomSectionTableViewCell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@property (nonatomic,assign) NSInteger stepCount;//步进值
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,assign) NSInteger nums;//默认0代表身高体重、7周报、30月报

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (weak, nonatomic) IBOutlet UILabel *yNameLbl;

-(void)initViewWithTopArr:(NSMutableArray *)topArr bottomArr:(NSMutableArray *)bottomArr xlineArr:(NSMutableArray *)xlineArr yLineArr:(NSMutableArray *)yLineArr yValueArr:(NSMutableArray *)yValueArr currentData:(CGPoint)redPoint;
@end
