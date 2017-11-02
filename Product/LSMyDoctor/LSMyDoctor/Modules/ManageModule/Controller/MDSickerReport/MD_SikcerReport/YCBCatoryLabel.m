//
//  YCBCatoryLabel.m
//  ladatu
//
//  Created by yunzujia on 16/11/9.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "YCBCatoryLabel.h"
#define YCBUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation YCBCatoryLabel
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.name = [[UILabel alloc] init];
        self.markLabel = [[UILabel alloc] init];
        //self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.name];
        [self addSubview:self.markLabel];
    }
    return self;
}


- (void)layoutSubviews{
    
    CGFloat nameH = 20;
    [self.name setFrame:CGRectMake(0, 0, self.frame.size.width, nameH)];
    self.name.layer.masksToBounds = YES;
    self.name.layer.cornerRadius = nameH / 2.0f;
    self.name.backgroundColor = YCBUIColorFromRGB(0x5593e8);
    self.name.textColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:13.3];
    [self.markLabel setFrame:CGRectMake(0, 0, 40, nameH)];
    self.name.textAlignment = NSTextAlignmentCenter;
    
    CGPoint cent = CGPointMake(self.frame.size.width / 2.0f, nameH + 10);
    self.markLabel.center = cent;
    self.markLabel.textAlignment = NSTextAlignmentCenter;
    self.markLabel.textColor = YCBUIColorFromRGB(0x5593e8);
    
}
@end
