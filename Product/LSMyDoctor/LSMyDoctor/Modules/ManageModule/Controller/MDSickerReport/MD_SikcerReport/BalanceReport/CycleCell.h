//
//  CycleCell.h
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceModel.h"
@interface CycleCell : UITableViewCell

@property (nonatomic, strong) BalanceGroups * model;

+ (CGFloat) cellHeight;

@end
