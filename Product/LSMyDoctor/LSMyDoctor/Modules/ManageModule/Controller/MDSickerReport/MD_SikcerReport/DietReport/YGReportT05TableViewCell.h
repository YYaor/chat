//
//  YGReportT05TableViewCell.h
//  YouGeHealth
//
//  Created by luuuujun on 05/11/2016.
//
//

#import <UIKit/UIKit.h>

@interface YGReportT05TableViewCell : UITableViewCell

// name: 早餐,午餐,晚餐
@property (nonatomic, copy ) NSString *namex;
@property (nonatomic, copy ) NSString *namey;
@property (nonatomic, copy ) NSString *namez;

//标准值,  总数为100，传入0～100数字
@property (nonatomic, assign) CGFloat standardx;//晚餐
@property (nonatomic, assign) CGFloat standardy;//午餐
@property (nonatomic, assign) CGFloat standardz;//早餐

//实际值
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat z;

@end
