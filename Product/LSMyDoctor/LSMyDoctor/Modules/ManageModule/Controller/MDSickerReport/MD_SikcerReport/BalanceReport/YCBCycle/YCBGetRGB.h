//
//  YCBGetRGB.h
//  ladatu
//
//  Created by yunzujia on 16/11/8.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YCBGetRGB : NSObject

@property (nonatomic, assign) CGFloat corlorR;

@property (nonatomic, assign) CGFloat corlorG;

@property (nonatomic, assign) CGFloat corlorB;

- (instancetype)initWithHexString:(NSString *)color;
@end
