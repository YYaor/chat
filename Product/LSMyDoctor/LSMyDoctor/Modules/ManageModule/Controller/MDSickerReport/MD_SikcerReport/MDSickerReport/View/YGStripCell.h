//
//  YGStripCell.h
//  YouGeHealth
//
//  Created by 惠生 on 16/12/8.
//
//

/////////////////T04  柱状图////////////////////////


#import <UIKit/UIKit.h>

@interface YGStripCell : UITableViewCell

@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic , strong) NSString * titleStr;//标题
@property (nonatomic , assign) BOOL left;//标题

@end
