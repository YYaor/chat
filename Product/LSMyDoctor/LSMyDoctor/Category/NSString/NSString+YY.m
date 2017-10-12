//
//  NSString+YY.m
//  mocha
//
//  Created by paozi-jun on 14-9-11.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import "NSString+YY.h"

@implementation NSString (YY)

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode{
    return [self sizeWithFont:font constrainedToSize:size];
}

-(CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

-(CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

+ (NSString*)priceFormatWith:(NSDecimalNumber *) value
{
    return (value.intValue == value.floatValue)?[NSString stringWithFormat:@"¥ %ld",(long)value.intValue]:[NSString stringWithFormat:@"¥ %.2f",value.floatValue];
}


- (NSMutableAttributedString *)LabelDefaultRowSpacingFormatStringWithFontSize:(CGFloat)size{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [self length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, [self length])];
    return attributedString;
    
}
@end
