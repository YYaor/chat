//
//  MDDataStatisticsCell.h
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDDataStatisticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *midTitleLab;//中间

@property (weak, nonatomic) IBOutlet UILabel *midValueLab;//中间值

@property (weak, nonatomic) IBOutlet UILabel *lefTitleLab;//左边

@property (weak, nonatomic) IBOutlet UILabel *leftValueLab;//左边

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLab;//右边

@property (weak, nonatomic) IBOutlet UILabel *rightValueLab;//右边

@end
