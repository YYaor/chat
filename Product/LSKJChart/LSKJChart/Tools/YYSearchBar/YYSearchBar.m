//
//  YYProductSearchBar.m
//  mocha
//
//  Created by CAT on 14-3-5.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import "YYSearchBar.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation YYSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.keyboardType = UIKeyboardTypeEmailAddress;

        self.barTintColor = [UIColor clearColor];
        self.searchBarStyle = UISearchBarStyleMinimal;
    }
    return self;
}

- (id)initWithSearchTab{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.keyboardType = UIKeyboardTypeEmailAddress;
        [self setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        self.barTintColor = [UIColor clearColor];
        self.searchBarStyle = UISearchBarStyleMinimal;
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];

    //删除iOS6下的背景
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            [view removeFromSuperview];
        }
    }
    
    //查找field
    UITextField *searchField = [self valueForKey:@"_searchField"];
    //修改系统默认的“取消”图标
//    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"ic_lib_close_icon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
//    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"ic_lib_close_icon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];

    if(searchField == nil){
        //ios7需要再循环一次
        for(UIView *subView in self.subviews){
            for(UIView *subSubView in subView.subviews){
                if([subSubView isKindOfClass:[UITextField class]]){
                    searchField = (UITextField *)subSubView;
                    break;
                }
            }
            if(searchField){
                break;
            }
        }
    }
    
    for(UIImageView *subView in [searchField subviews]){
        if([subView isKindOfClass:[UIImageView class]]){
            [subView setImage:[UIImage imageNamed:@"search"]];
            CGSize viewSize = subView.frame.size;
            viewSize.width = 20;
            viewSize.height = 20;
            subView.bounds = CGRectMake(0, 0, viewSize.width, viewSize.height);
        }
    };
    
    
    searchField.background = nil;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.textColor = [UIColor colorFromHexString:@"0x555555"];
    searchField.tintColor = [UIColor colorFromHexString:@"0x589715"];
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 4;
    searchField.layer.borderWidth = 0.6;
    searchField.layer.borderColor = [UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1].CGColor;
    searchField.frame = CGRectMake(14, 12, searchField.frame.size.width-14, 40);
    //placeholder
    NSMutableAttributedString *attributedPlaceholder;
    if (self.placeString) {
        attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:self.placeString];
    }else{
        attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"输入患者姓名"];
    }
    [attributedPlaceholder addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor colorWithWhite:0xbf/255.0 alpha:1] range:NSMakeRange(0, attributedPlaceholder.length)];
    searchField.attributedPlaceholder = attributedPlaceholder;
    
    //        [clearButton setImage:[UIImage imageNamed:@"ic_lib_close_icon_gray"] forState:UIControlStateNormal];
}

@end
