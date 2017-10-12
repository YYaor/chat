//
//  LSDataPickerView.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSDataPickerView.h"

@interface LSDataPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, copy) NSString *selectedStr;

@end

@implementation LSDataPickerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self initForView];
}

- (void)initForView
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)setPickerWithArray:(NSArray *)dataList title:(NSString *)title
{
    self.dataList = dataList;
    self.title.text = title;
}

- (IBAction)leftItem:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (IBAction)rightItem:(UIButton *)btn
{
    [self removeFromSuperview];
    
    if (self.selected)
    {
        self.selected(self.selectedStr);
    }
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataList[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lab = (UILabel *)view;
    if (!lab)
    {
        lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor redColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16];
    }
    lab.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return lab;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedStr = self.dataList[row];
}

@end
