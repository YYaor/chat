//
//  YCBGetRGB.m
//  ladatu
//
//  Created by yunzujia on 16/11/8.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "YCBGetRGB.h"

@implementation YCBGetRGB

- (instancetype)initWithHexString:(NSString *)color{
    
    if (self = [super init]) {
        self.corlorR = 0;
        self.corlorG = 0;
        self.corlorB = 0;
        NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        
        // String should be 6 or 8 characters
        if ([cString length] < 6) {
          
        }else{
            if ([cString hasPrefix:@"0X"])
                cString = [cString substringFromIndex:2];
            if ([cString hasPrefix:@"#"])
                cString = [cString substringFromIndex:1];
            if ([cString length] != 6){
               
            }else{
                // strip 0X if it appears
                // Separate into r, g, b substrings
                NSRange range;
                range.location = 0;
                range.length = 2;
                
                //r
                NSString *rString = [cString substringWithRange:range];
                
                //g
                range.location = 2;
                NSString *gString = [cString substringWithRange:range];
                
                //b
                range.location = 4;
                NSString *bString = [cString substringWithRange:range];
                
                // Scan values
                unsigned int r, g, b;
                [[NSScanner scannerWithString:rString] scanHexInt:&r];
                [[NSScanner scannerWithString:gString] scanHexInt:&g];
                [[NSScanner scannerWithString:bString] scanHexInt:&b];
                
                self.corlorR = (CGFloat)r;
                self.corlorG = (CGFloat)g;
                self.corlorB = (CGFloat)b;

            }
        }
    }
    return self;
}


@end
