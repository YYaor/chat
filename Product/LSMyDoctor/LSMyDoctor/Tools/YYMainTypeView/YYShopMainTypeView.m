//
//  YYShopMainTypeView.m
//  mocha
//
//  Created by 向文品 on 14-8-4.
//  Copyright (c) 2014年 yunyao. All rights reserved.
//

#import "YYShopMainTypeView.h"

#define selectFont [UIFont boldSystemFontOfSize:14]
#define normalFont [UIFont systemFontOfSize:14]

#define IMAGEANDTEXTFONT [UIFont systemFontOfSize:15]

#define TOUTIAOSELECTFONT [UIFont systemFontOfSize:16]
#define TOUTIAONORMALFONT [UIFont systemFontOfSize:14]
@implementation YYShopMainTypeView
{
    UIView *selectView;
    NSInteger itemCount;
    NSMutableArray *buttonArray;
    horizontalViewType viewType;
}

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        itemCount = filters.count;
        selectView = [[UIView alloc] init];
        buttonArray = [NSMutableArray array];
        
        selectView.frame = CGRectMake(0, frame.size.height-5, frame.size.width/itemCount, 3);
        [self addSubview:selectView];
        CALayer *greenLayer = [[CALayer alloc] init];
        greenLayer.backgroundColor = [UIColor colorFromHexString:@"ffffff"].CGColor;
        greenLayer.cornerRadius = selectView.frame.size.height/2;
        greenLayer.frame = CGRectMake(0, 0, selectView.frame.size.width, 2);
        [selectView.layer addSublayer:greenLayer];
        
        for (NSInteger i=0; i<filters.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/filters.count*i, 3, frame.size.width/filters.count, frame.size.height-3)];
            [button setTitle:[filters objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHexString:@"ffffff"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorFromHexString:@"ffffff"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                button.selected = YES;
            }
            button.tag = i;
            [button addTarget:self action:@selector(selectTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonArray addObject:button];
        }
    }
    return self;
}

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters picNormalArr:(NSArray *)pictureNameNormalArr picSelectedArr:(NSArray *)pictureNameSelectedArr isJingxuan:(BOOL)isJing viewType:(horizontalViewType)horizontalViewType
{
    viewType = horizontalViewType;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isJingxuan = isJing;
        
        itemCount = filters.count;
        selectView = [[UIView alloc] init];
        buttonArray = [NSMutableArray array];

        selectView.frame = CGRectMake(0, frame.size.height-5, frame.size.width/itemCount, 3);
        [self addSubview:selectView];
        CALayer *greenLayer = [[CALayer alloc] init];
        greenLayer.backgroundColor = [UIColor colorFromHexString:@"333333"].CGColor;
        greenLayer.cornerRadius = selectView.frame.size.height/2;
//        NSString *fiter = filters[0];
//        CGFloat width = [fiter sizeWithFont:TOUTIAOSELECTFONT].width;
//        greenLayer.frame = CGRectMake(selectView.frame.size.width/2-width/2, 0, width, 2.5);
        greenLayer.frame = CGRectMake(selectView.center.x - 25, 0, 50, 2);
        [selectView.layer addSublayer:greenLayer];
        
        for (NSInteger i=0; i<filters.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/filters.count*i, 3, frame.size.width/filters.count, frame.size.height-3)];
                [button setTitle:[filters objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateSelected];
            if (isJing) {
                [button setTitleColor:[UIColor colorWithWhite:0x99/255.0 alpha:1] forState:UIControlStateNormal];

            }else{
                [button setTitleColor:[UIColor colorWithWhite:0x33/255.0 alpha:1] forState:UIControlStateNormal];
            }
            
            if (i == 0) {
                button.selected = YES;
                button.titleLabel.font = TOUTIAOSELECTFONT;
            }else{
                button.titleLabel.font = TOUTIAONORMALFONT;
            }
            button.tag = i;
            [button addTarget:self action:@selector(selectTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonArray addObject:button];
        }
    }
    return self;
}

-(void)hideSelectedView{
    selectView.hidden = YES;
}

-(void)updateFilters:(NSArray *)filters{
     for (NSInteger i=0; i<filters.count; i++) {
         UIButton *button = [buttonArray objectAtIndex:i];
         [button setTitle:[filters objectAtIndex:i] forState:UIControlStateNormal];
     }
}

-(void)select:(UIButton *)b{
    for (UIView *v in b.superview.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [(UIButton *)v setSelected:NO];
            [(UIButton *)v titleLabel].font = TOUTIAONORMALFONT;
        }
    }
    b.selected = YES;
    b.titleLabel.font = TOUTIAOSELECTFONT;
}

-(void)selectTypeButtonClick:(UIButton *)b{
    [self select:b];
    CGRect frame = selectView.frame;
    frame.origin.x = self.frame.size.width/itemCount*b.tag;
    if (viewType == horizontalViewTypeLeftImageAndRightTextType) {
        frame.origin.x += 5;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    self.selectIndex = b.tag;
    if ([self.delegate respondsToSelector:@selector(selectTypeIndex:)]) {
        [self.delegate selectTypeIndex:b.tag];
    }
}

-(void)selectToIndex:(NSInteger)index{
    UIButton *button;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]] && v.tag == index) {
            button = (UIButton *)v;
            break;
        }
    }
    [self select:button];

    //选中 下标view
    if (button) {
        CGRect frame = selectView.frame;
        frame.origin.x = (self.frame.size.width/itemCount*button.tag);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            selectView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

-(void)selectToValue:(float)offestX{
    CGRect frame = selectView.frame;
    frame.origin.x = offestX*self.frame.size.width;
    selectView.frame = frame;
}

@end
