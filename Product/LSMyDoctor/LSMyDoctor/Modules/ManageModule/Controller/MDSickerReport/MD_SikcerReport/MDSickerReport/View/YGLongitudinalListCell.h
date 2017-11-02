//
//  YGLongitudinalListCell.h
//  YouGeHealth
//
//  Created by 惠生 on 16/11/11.
//
//

///////////////////// T23 纵向表格 /////////////////////////////

#import <UIKit/UIKit.h>

@interface YGLongitudinalListCell : UITableViewCell

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,strong) ReportItemDataModel *dataModel;
@property (nonatomic,copy) NSDictionary *dict;//传入值

@end
