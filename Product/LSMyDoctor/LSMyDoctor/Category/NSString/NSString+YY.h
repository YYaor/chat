//
//  NSString+YY.h
//  mocha
//
//  Created by paozi-jun on 14-9-11.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YY)

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

-(CGSize)sizeWithFont:(UIFont *)font;

/*
 * 传入：NSDecimalNumber类型的价格参数
 * 传出：如果小数为为0，则返回整数价格形式的字符串，反之返回包含两位有效小数的价格形式的字符串
 */
+ (NSString*)priceFormatWith:(NSDecimalNumber *)value;

/**
 * 将string转化问富文本格式.默认只添加行间距.
 */
- (NSMutableAttributedString *)LabelDefaultRowSpacingFormatStringWithFontSize:(CGFloat)size;
@end
