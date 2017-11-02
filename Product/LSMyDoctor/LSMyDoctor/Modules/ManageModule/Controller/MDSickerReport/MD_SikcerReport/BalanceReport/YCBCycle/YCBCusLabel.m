//
//  YCBCusLabel.m
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "YCBCusLabel.h"
#define YCBUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface YCBCusLabel()



@end
@implementation YCBCusLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       // self.backgroundColor = [UIColor yellowColor];
        self.lab1 = [[UILabel alloc] init];
        self.lab2 = [[UILabel alloc] init];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
    }
    return self;
}

- (void)layoutSubviews{
    self.lab1.frame = CGRectMake(0, 0, 20, 20);
//    self.lab1.backgroundColor = YCBUIColorFromRGB(0xffb434);
    self.lab1.layer.masksToBounds = YES;
    self.lab1.layer.cornerRadius = 3.0;
    
    self.lab2.font = [UIFont systemFontOfSize:16];
    self.lab2.frame = CGRectMake(30, 0, self.frame.size.width - 30, 20);
    
    
}

@end
