//
//  YGReportT06TableViewCell.m
//  YouGeHealth
//
//  Created by luuuujun on 05/11/2016.
//
//

#import "YGReportT06TableViewCell.h"

@interface YGReportT06TableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourRangeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourValueLabel;
@property (weak, nonatomic) IBOutlet UIView *rangeBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *yourRangeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yourRangeViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yourRangeViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yourValueLabelCenterXConstraint;

@end

@implementation YGReportT06TableViewCell

- (void)awakeFromNib
{
    _name = @"NA";
    _unit = @"NA";
    _minValue = 0;
    _maxValue = 9999;
    _yourMinValue = 99;
    _yourMaxValue = 999;
    _yourValue = 199;
    [self setupInternalViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateInternalViews];
}

#pragma mark - Getters/Setters

- (void)setName:(NSString *)name
{
    _name = name;
    _nameLabel.text = name;
}

- (void) setUnit:(NSString *)unit
{
    _unit = unit;
    static NSString *formatString = @"(单位: %@)";
    _unitLabel.text = [NSString stringWithFormat:formatString, unit];
}

- (void)setMaxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    _maxValueLabel.text = [NSString stringWithFormat:@"%ld", (long)maxValue];
}

- (void)setMinValue:(NSInteger)minValue
{
    _minValue = minValue;
    _minValueLabel.text = [NSString stringWithFormat:@"%ld", (long)minValue];
}

- (void) setYourMaxValue:(NSInteger)yourMaxValue
{
    _yourMaxValue = yourMaxValue;
    [self updateInternalViews];
}

- (void)setYourMinValue:(NSInteger)yourMinValue
{
    _yourMinValue = yourMinValue;
    [self updateInternalViews];
}

- (void)setYourValue:(NSInteger)yourValue
{
    _yourValue = yourValue;
    [self updateInternalViews];
}

#pragma mark - Internal Methods

- (void) setBorderRadiusForView: (UIView*) view radius: (CGFloat) radius borderColor: (UIColor*) color
{
    // 设置背景控件圆角
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius: radius];       //设置矩形四个圆角半径
    [view.layer setBorderWidth : 1.0];          //边框宽度
    [view.layer setBorderColor:color.CGColor];  //边框颜色
}

- (void) setupInternalViews
{
    // 设置背景圆角
    [self setBorderRadiusForView:self.rangeBackgroundView radius:5.0f borderColor:self.rangeBackgroundView.backgroundColor];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"<%@: %p, %@>", [self class], self,
                      @{
                        @"name" : _name,
                        @"unit" : _unit,
                        @"minValue": @(_minValue),
                        @"maxValue" : @(_maxValue),
                        @"yourMinValue" : @(_yourMinValue),
                        @"yourMaxValue" : @(_yourMaxValue),
                        @"yourValue" : @(_yourValue)
                       }
                      ];
    return desc;
}

- (void) updateInternalViews
{
    NSInteger totalRange = self.maxValue - self.minValue;
    if (self.minValue < 0 || self.minValue < self.maxValue || totalRange <= 0)
    {
        //NSLog(@"ERROR ===== totalRange <= 0, %@", self);
    }
    
    NSInteger yourRange = self.yourMaxValue - self.yourMinValue;
    if (self.yourMinValue < 0 || self.yourMinValue < self.yourMaxValue || yourRange <= 0)
    {
        //NSLog(@"ERROR ===== yourRange <= 0, %@", self);
    }
    
    // 设置个人区间值
    self.yourRangeValueLabel.text = [NSString stringWithFormat:@"%d-%d", (int)self.yourMinValue, (int)self.yourMaxValue];
    
    // 设置个人值
    self.yourValueLabel.text = [NSString stringWithFormat:@"%d", (int) self.yourValue];
    
    // 根据输入调整个人区间View的位置
    CGFloat backgroundWidth = kScreenWidth - 80;
    if (totalRange > 0) {
        self.yourRangeViewLeadingConstraint.constant = self.yourMinValue * 1.0 * backgroundWidth / totalRange;
        self.yourRangeViewWidthConstraint.constant = backgroundWidth * yourRange * 1.0 / totalRange;
        
        // 设置个人值的位置
        NSString * positionStr = [NSString stringWithFormat:@"%f",self.yourValue * 1.0/ totalRange * backgroundWidth];
        
        CGFloat position = (float)[positionStr integerValue];
        if(self.yourValue > 1000){
            
        }
        
        self.yourValueLabelCenterXConstraint.constant = position;
        CGFloat threshold = 12;
//        self.minValueLabel.hidden = position < threshold ? YES : NO;
    }
    
}

@end
