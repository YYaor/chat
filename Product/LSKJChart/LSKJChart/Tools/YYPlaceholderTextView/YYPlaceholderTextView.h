//
//  YYTextView.h
//  mocha
//
//  Created by AIR on 13-5-27.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYPlaceholderTextView : UITextView

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
