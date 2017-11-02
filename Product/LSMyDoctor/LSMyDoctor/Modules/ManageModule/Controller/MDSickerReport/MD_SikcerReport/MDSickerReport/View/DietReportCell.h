//
//  DietReportCell.h
//  YouGeHealth
//
//  Created by yunzujia on 16/10/26.
//
//

#import <UIKit/UIKit.h>

@interface DietReportCell : UITableViewCell
@property (nonatomic, assign) NSInteger min;//最小值
@property (nonatomic, assign) NSInteger max;//最大
@property (nonatomic, assign) NSInteger smin;//标准最小
@property (nonatomic, assign) NSInteger smax;//标准最大
@property (nonatomic, assign) NSInteger pre;//自己的位置
@end
