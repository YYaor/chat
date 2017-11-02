//
//  CycleCell.m
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "CycleCell.h"
#import "YCBCycleView.h"

#define  YScreenW             [UIScreen mainScreen].bounds.size.width
#define  YScreenH             [UIScreen mainScreen].bounds.size.height
#define YCBUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation CycleCell{
    YCBCycleView * cycle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)layoutSubviews{
    if (!self.model) {
        if (cycle) {
            [cycle removeFromSuperview];
            cycle = nil;
        }
        cycle = [[YCBCycleView alloc] initWithFrame:CGRectMake(0, 0, YScreenW, YScreenW * 0.72)];
    }
    
    
    [self.contentView addSubview:cycle];

}

+ (CGFloat) cellHeight
{
    return YScreenW * 0.72 + 50;
}


- (void)setModel:(BalanceGroups *)model{
    _model = model;
    if (cycle) {
        [cycle removeFromSuperview];
        cycle = nil;
    }
    cycle = [[YCBCycleView alloc] initWithFrame:CGRectMake(0, 0, YScreenW, 300)];
    if (model.items[0].data.list.count > 0) {
        
        NSString * value = model.items[0].data.list[2][@"value"];
        cycle.workDrain = value.floatValue;
        
        NSString * value1 = model.items[0].data.list[1][@"value"];
        cycle.sportDrain = value1.floatValue;
        
        NSString * value2 = model.items[0].data.list[0][@"value"];
        cycle.baseDrain = value2.floatValue;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
