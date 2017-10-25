//
//  LSMineHeaderView.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMineHeaderView : UIView

@property (nonatomic,weak) id controller;

-(void)updateWithImageURL:(NSString *)imageURL name:(NSString *)name career:(NSString *)career;

@end
