//
//  LSMineListCell.h
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMineListCell : UITableViewCell

-(void)updateCellWithIcon:(NSString *)icon title:(NSString *)title;

-(void)hideBottomLine:(BOOL)hide;

@end
