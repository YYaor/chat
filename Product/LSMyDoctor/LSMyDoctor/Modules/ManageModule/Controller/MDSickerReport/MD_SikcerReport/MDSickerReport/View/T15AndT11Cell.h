//
//  T15AndT11Cell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/12/29.
//
//

#import <UIKit/UIKit.h>

@interface T15AndT11Cell : UITableViewCell

@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic,assign) NSInteger stepCount;//步进值
@property (nonatomic,strong) NSIndexPath *path;
@property (nonatomic,copy) NSString *textStr;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@end
