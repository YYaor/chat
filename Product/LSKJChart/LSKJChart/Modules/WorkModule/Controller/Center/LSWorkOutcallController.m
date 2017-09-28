//
//  LSWorkOutcallController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/29.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallController.h"

@interface LSWorkOutcallController () <FSCalendarDelegate, FSCalendarDataSource>

@property (nonatomic, strong) FSCalendar *calendar;

@end

@implementation LSWorkOutcallController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"出诊记录";
    
    [self.view addSubview:self.calendar];
}

#pragma mark - FSCalendarDelegate

#pragma mark - FSCalendarDataSource

#pragma mark - getter & setter

- (FSCalendar *)calendar
{
    if (!_calendar)
    {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 60, LSSCREENWIDTH, LSSCREENWIDTH)];
        
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.appearance.headerTitleColor = [UIColor blackColor];
        _calendar.appearance.weekdayTextColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
        _calendar.appearance.todayColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _calendar.appearance.selectionColor = [UIColor clearColor];
        _calendar.appearance.titleSelectionColor = [UIColor blackColor];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        
    }
    return _calendar;
}

@end
