//
//  YGT02Cell.h
//  YouGeHealth
//
//  Created by 惠生 on 16/12/9.
//
//

#import <UIKit/UIKit.h>

@interface YGT02Cell : UITableViewCell

@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic, assign) BOOL showMarkLabel;	//是否显示每一项的分数值

@end
