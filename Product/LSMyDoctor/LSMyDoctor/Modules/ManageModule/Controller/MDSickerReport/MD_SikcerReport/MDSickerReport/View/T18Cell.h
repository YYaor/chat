//
//  T18Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import <UIKit/UIKit.h>

@interface T18Cell : UITableViewCell
{
    NSString *blueName;
    NSString *yellowName;
}

typedef void(^DetailBtnBlock)(ReportItemModel *itemDetailModel);

@property (nonatomic,assign) NSInteger colNum;//x轴日期两个点之间间隔天数

@property (nonatomic,strong) ReportItemDataModel *dataModel;


@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,copy) DetailBtnBlock detailBlock;//详情按钮点击回调

@end
