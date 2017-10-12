//
//  LSDataPickerView.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDataPickerView : UIView

@property (nonatomic, copy) void (^selected) (NSString *str);

- (void)setPickerWithArray:(NSArray *)dataList title:(NSString *)title;
- (void)show;

@end
