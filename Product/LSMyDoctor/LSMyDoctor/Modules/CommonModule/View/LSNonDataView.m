//
//  LSNonDataView.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/12/7.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSNonDataView.h"

@interface LSNonDataView ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation LSNonDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initForView];
    }
    return self;
}

- (void)initForView
{
    [self addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - getter & setter

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"无数据";
    }
    return _titleLab;
}

- (void)setTitleStr:(NSString *)titleStr
{
    self.titleLab.text = titleStr;
}

@end
