//
//  YYTextView.m
//  mocha
//
//  Created by AIR on 13-5-27.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#import "YYPlaceholderTextView.h"

@implementation YYPlaceholderTextView
{
    BOOL _shouldDrawPlaceholder;
}
- (void)setText:(NSString *)string {
	[super setText:string];
	[self _updateShouldDrawPlaceholder];
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}
    
	_placeholder = string;
	[self _updateShouldDrawPlaceholder];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
	if (_shouldDrawPlaceholder) {
		[_placeholderTextColor set];
        
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : self.placeholderTextColor, NSFontAttributeName : self.font};
        
        [_placeholder drawInRect:CGRectMake(4.0f, 8.0f, self.frame.size.width - 8.0f, self.frame.size.height - 16.0f) withAttributes:attrs];
	}
}


#pragma mark - Private
- (void)_initialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
	_shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
	
	_shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0 && self.attributedText.string.length == 0;
    [self setNeedsDisplay];
}


- (void)_textChanged:(NSNotification *)notification {
	[self _updateShouldDrawPlaceholder];
}

#pragma mark - NSObject
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
