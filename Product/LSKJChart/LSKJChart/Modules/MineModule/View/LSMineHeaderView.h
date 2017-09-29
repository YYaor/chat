//
//  LSMineHeaderView.h
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMineHeaderView : UIView

@property (nonatomic,weak) id controller;

-(void)updateWithImageURL:(NSString *)imageURL name:(NSString *)name room:(NSString *)room career:(NSString *)career;

@end
