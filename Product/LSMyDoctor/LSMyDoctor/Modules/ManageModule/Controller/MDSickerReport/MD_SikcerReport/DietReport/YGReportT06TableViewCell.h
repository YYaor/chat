//
//  YGReportT06TableViewCell.h
//  YouGeHealth
//
//  Created by luuuujun on 05/11/2016.
//
//

#import <UIKit/UIKit.h>

@interface YGReportT06TableViewCell : UITableViewCell

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *unit;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger yourMinValue;
@property (nonatomic, assign) NSInteger yourMaxValue;
@property (nonatomic, assign) NSInteger yourValue;

@end
