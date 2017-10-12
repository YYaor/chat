//
//  LSWorkOutcallController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/29.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallController.h"

#import "LSWorkOutcallListController.h"

@interface LSWorkOutcallController () <FSCalendarDelegate, FSCalendarDataSource>

@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) NSMutableArray *dataArr;

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
    
    self.dataArr = [NSMutableArray array];
    
    [self.view addSubview:self.calendar];
}

- (NSDate *)changDateForUTCWithDate:(NSDate *)date
{
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return destinationDateNow;
}

- (NSComparisonResult)isBiggerThanToday:(NSDate *)date
{
    //转为现在时间
    NSDate *nowDate = [self changDateForUTCWithDate:[NSDate date]];
    NSDate *compareDate = [self changDateForUTCWithDate:date];

    NSComparisonResult result = [compareDate compare:nowDate];
    
    return result;
}

- (BOOL)isCurrentMonth:(NSDate *)date
{
    BOOL result = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSDate *nowDate = [self changDateForUTCWithDate:[NSDate date]];
    NSDate *compareDate = [self changDateForUTCWithDate:date];
    
    NSInteger nowMonth = [[[formatter stringFromDate:nowDate] componentsSeparatedByString:@"-"][1] integerValue];
    NSInteger compareMonth = [[[formatter stringFromDate:compareDate] componentsSeparatedByString:@"-"][1] integerValue];
    
    if (nowMonth != compareMonth)
    {
        result = NO;
    }
    
    return result;
}

//- (BOOL)isToday:(NSDate *)date
//{
//    BOOL result = NO;
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *nowDate = [self changDateForUTCWithDate:[NSDate date]];
//    NSDate *compareDate = [self changDateForUTCWithDate:date];
//    
//    if ([[[formatter stringFromDate:nowDate] componentsSeparatedByString:@"-"][0] isEqualToString:[[formatter stringFromDate:compareDate] componentsSeparatedByString:@"-"][0]] && [[[formatter stringFromDate:nowDate] componentsSeparatedByString:@"-"][1] isEqualToString:[[formatter stringFromDate:compareDate] componentsSeparatedByString:@"-"][1]] && [[[formatter stringFromDate:nowDate] componentsSeparatedByString:@"-"][2] isEqualToString:[[formatter stringFromDate:compareDate] componentsSeparatedByString:@"-"][2]])
//    {
//        result = YES;
//    }
//    
//    return result;
//}

//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    FSCalendarCell *cell = [calendar cellForDate:date atMonthPosition:monthPosition];
    
    if ([cell.titleLabel.textColor isEqual:[UIColor colorFromHexString:LSDARKGRAYCOLOR]])
    {
        return NO;
    }
    
    return YES;
    
//    if ([self isBiggerThanToday:date] > 0)
//    {
//        return NO;
//    }
//    else if ([self isCurrentMonth:date])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [calendar deselectDate:date];
    
    LSWorkOutcallListController *vc = [[LSWorkOutcallListController alloc] initWithNibName:@"LSWorkOutcallListController" bundle:nil];
    vc.date = [self changDateForUTCWithDate:date];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if ([self isBiggerThanToday:date] > 0)
    {
        cell.titleLabel.textColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
    }

}

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
        _calendar.appearance.titleDefaultColor = [UIColor blackColor];
        _calendar.appearance.todayColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _calendar.appearance.todaySelectionColor = [UIColor colorFromHexString:LSGREENCOLOR];
        _calendar.appearance.selectionColor = [UIColor clearColor];
//        _calendar.appearance.titleSelectionColor = [UIColor blackColor];
        _calendar.appearance.titlePlaceholderColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        
        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(10, 0, _calendar.rowHeight, _calendar.rowHeight);
        previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [previousButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_calendar addSubview:previousButton];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(LSSCREENWIDTH-10-_calendar.rowHeight, 0, _calendar.rowHeight, _calendar.rowHeight);
        nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        nextButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_calendar addSubview:nextButton];
        
    }
    return _calendar;
}

@end
