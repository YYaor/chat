//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface FyCalendarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *daysArray;
@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDate];
        [self setupNextAndLastMonthView];
    }
    frame.size.height=self.frame.size.height+50;
    self.frame=frame;
    return self;
}

- (void)setupDate {
    self.daysArray = [NSMutableArray arrayWithCapacity:42];
    for (int i = 0; i < 42; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [_daysArray addObject:button];
        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupNextAndLastMonthView {
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:@"left_public"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    self.leftBtn.tag = 1;
    self.leftBtn.frame = CGRectMake(10, 10, 60, 30);
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
    self.rightBtn.tag = 2;
    [self.rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    self.rightBtn.frame = CGRectMake(self.frame.size.width - 70, 10, 60, 30);
    
    if ([self.markStr isEqualToString:@"1001"]) {
        //签到
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
}

- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
//        if (!_date) {
//            return;
//        }
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    _date = date;
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.width / 7;
    
    // 1.year month
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text     = [NSString stringWithFormat:@"%li年%li月",(long)[self year:date],(long)[self month:date]];
    NSLog(@"%@", self.headlabel.text);
    self.headlabel.font     = [UIFont systemFontOfSize:19];
    self.headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, itemH);
    self.headlabel.textAlignment   = NSTextAlignmentCenter;
    self.headlabel.textColor = self.headColor;
    [self addSubview: self.headlabel];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor = [UIColor clearColor];
    headBtn.frame = self.headlabel.frame;
    [headBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headlabel];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekBg = [[UIView alloc] init];
//    self.weekBg.backgroundColor = [UIColor orangeColor];
//
//    self.backgroundColor = [UIColor cyanColor];
    
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), self.frame.size.width, itemH-20);
    if([self.markStr isEqualToString:@"1001"]){
        self.weekBg.frame = CGRectMake(0, 0, self.frame.size.width, itemH-20);
    }
    [self addSubview:self.weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:17];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = self.weekDaysColor;
        [self.weekBg addSubview:week];
    }
    if ([self.markStr isEqualToString:@"1001"]) {
        //签到日历特殊标识
        self.headlabel.hidden = YES;
        
        //  3.days (1-31)
        for (int i = 0; i < 42; i++) {
            
            int x = (i % 7) * itemW ;
            int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame)+20;
            
            UIView* dayView = [[UIView alloc] init];
            dayView.frame = CGRectMake(x, y-20, itemW, itemH);
            dayView.layer.masksToBounds = YES;
            dayView.layer.borderColor = UIColorFromRGB(0xefefef).CGColor;
            dayView.layer.borderWidth = 0.5f;
            
            [self addSubview:dayView];
            
            //日期
            UILabel* dayLab = [[UILabel alloc] init];
            dayLab.font = [UIFont systemFontOfSize:13.0f];
            
            [dayView addSubview:dayLab];
            [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dayView.mas_top).offset(5);
                make.left.equalTo(dayView.mas_left).offset(5);
            }];
            
            NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
            NSInteger daysInThisMonth = [self totaldaysInMonth:date];
            NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
            
            NSInteger day = 0;
            
            
            if (i < firstWeekday) {
                day = daysInLastMonth - firstWeekday + i + 1;
                if (self.isShowOnlyMonthDays) {
                    dayView.hidden = YES;
                } else {
                    dayLab.textColor = [UIColor clearColor];
//                    iconBtn.hidden = YES;
                    
                }
                
            }else if (i > firstWeekday + daysInThisMonth - 1){
                day = i + 1 - firstWeekday - daysInThisMonth;
                if (self.isShowOnlyMonthDays) {
                    dayView.hidden = YES;
                } else {
                    dayLab.textColor = [UIColor clearColor];
//                    iconBtn.hidden = YES;
                    
                }
                
            }else{
                day = i - firstWeekday + 1;
                dayLab.text = [NSString stringWithFormat:@"%li", (long)day];
//                [self setSignUpStatus:iconBtn withTitle:dayLab.text];
            }
            dayLab.text = [NSString stringWithFormat:@"%li", (long)day];
            
            
            // this month
            
            if ([self year:date]==[self year:[NSDate date]]){
                if ([self month:date] == [self month:[NSDate date]]) {
                    
                    NSInteger days=[self day:date];
                    if ([self month:date]==7) {
                        
                    }
                    
                    NSInteger todayIndex = days + firstWeekday - 1;
                    
                    if (i < todayIndex && i >= firstWeekday) {
                        
                    }else if(i ==  todayIndex){
                        
                        day = i - firstWeekday + 1;
                        dayLab.text = [NSString stringWithFormat:@"%li", (long)day];
                        
//                        [self setStyle_Today:dayButton];
                    }else
                    {
                        dayLab.textColor = [UIColor lightGrayColor];
//                        iconBtn.hidden = YES;
                    }
                }
            }
            
            if ([self year:date]<[self year:[NSDate date]]) {
                self.rightBtn.enabled=YES;
                [self.rightBtn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
                if ([self.markStr isEqualToString:@"1001"]) {
                    self.rightBtn.hidden = YES;
                    self.leftBtn.hidden = YES;
                }
            }else if ([self year:date]==[self year:[NSDate date]]) {
                if ([self month:date]==[self month:[NSDate date]]) {
                    
                    NSInteger days=[self day:date];
                    if ([self month:date]==7) {
                        //                    days=31;
                    }
                    
                    NSInteger todayIndex = days + firstWeekday - 1;
                    if(i > todayIndex){
//                        [self setStyle_BeyondThisMonth:dayButton];
                        self.rightBtn.enabled=NO;
                        [self.rightBtn setImage:[UIImage imageNamed:@"nextmonth_disabled"] forState:UIControlStateNormal];
                        if ([self.markStr isEqualToString:@"1001"]) {
                            self.rightBtn.hidden = YES;
                            self.leftBtn.hidden = YES;
                        }
                    }else if(i == todayIndex){
                        
                        day = i - firstWeekday + 1;
                        dayLab.text = [NSString stringWithFormat:@"%li", (long)day];
                        
                    }
                    
                }
            }else{
                
            }
        }//for循环结束

    }else{
        //非签到
        
        //  3.days (1-31)
        for (int i = 0; i < 42; i++) {
            
            int x = (i % 7) * itemW ;
            int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame)+20;
            
            UIButton *dayButton = _daysArray[i];
            dayButton.frame = CGRectMake(x, y-20, itemW, itemH);
            dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            dayButton.layer.cornerRadius = 5.0f;
            //        [dayButton setBackgroundColor:[UIColor cyanColor]];
            [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
            NSInteger daysInThisMonth = [self totaldaysInMonth:date];
            NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
            
            NSInteger day = 0;
            
            
            if (i < firstWeekday) {
                day = daysInLastMonth - firstWeekday + i + 1;
                [self setStyle_BeyondThisMonth:dayButton];//setStyle_BeforeToday
                
            }else if (i > firstWeekday + daysInThisMonth - 1){
                day = i + 1 - firstWeekday - daysInThisMonth;
                [self setStyle_BeyondThisMonth:dayButton];
                
            }else{
                day = i - firstWeekday + 1;
                [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
                [self setStyle_AfterToday:dayButton];
            }
            dayButton.tag=day;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            dayButton.titleLabel.font = [UIFont systemFontOfSize:21];
            
            // this month
            
            if ([self year:date]==[self year:[NSDate date]]){
                if ([self month:date] == [self month:[NSDate date]]) {
                    
                    NSInteger days=[self day:date];
                    if ([self month:date]==7) {
                        //                    days=31;
                    }
                    
                    NSInteger todayIndex = days + firstWeekday - 1;
                    
                    if (i < todayIndex && i >= firstWeekday) {
                        //                    [self setStyle_BeforeToday:dayButton];//暂时，需要屏蔽
                    }else if(i ==  todayIndex){
                        
                        day = i - firstWeekday + 1;
                        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
                        [self setStyle_Today:dayButton];
                    }
                }
            }
            
            if ([self year:date]<[self year:[NSDate date]]) {
                self.rightBtn.enabled=YES;
                [self.rightBtn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
                if ([self.markStr isEqualToString:@"1001"]) {
                    self.rightBtn.hidden = YES;
                    self.leftBtn.hidden = YES;
                }
            }else if ([self year:date]==[self year:[NSDate date]]) {
                if ([self month:date]==[self month:[NSDate date]]) {
                    
                    NSInteger days=[self day:date];
                    if ([self month:date]==7) {
                        //                    days=31;
                    }
                    
                    NSInteger todayIndex = days + firstWeekday - 1;
                    if(i > todayIndex){
                        [self setStyle_BeyondThisMonth:dayButton];
                        self.rightBtn.enabled=NO;
                        [self.rightBtn setImage:[UIImage imageNamed:@"nextmonth_disabled"] forState:UIControlStateNormal];
                        if ([self.markStr isEqualToString:@"1001"]) {
                            self.rightBtn.hidden = YES;
                            self.leftBtn.hidden = YES;
                        }
                    }else if(i == todayIndex){
                        
                        day = i - firstWeekday + 1;
                        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
                        [self setStyle_Today:dayButton];
                    }else{
                        //                    [self setStyle_BeforeToday:dayButton];
                        //                    [self.rightBtn setImage:[UIImage imageNamed:@"nextday"] forState:UIControlStateNormal];
                    }
                }else{
                    //                [self setStyle_BeforeToday:dayButton];
                    self.rightBtn.enabled=YES;
                    //                [self.rightBtn setImage:[UIImage imageNamed:@"nextday"] forState:UIControlStateNormal];
                }
            }else{
                //            [self setStyle_BeyondThisMonth:dayButton];
                self.rightBtn.enabled=NO;
                //            [self.rightBtn setImage:[UIImage imageNamed:@"nextday_disabled"] forState:UIControlStateNormal];
            }
        }//for循环结束

    }
    
}

#pragma mark - chooseMonth
- (void)chooseMonth:(UIButton *)button {
    //下期版本
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    
    self.selectBtn.selected = NO;
//    [self.selectBtn setBackgroundColor:[UIColor clearColor]];
//    [self.selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    for (UIView *v in self.selectBtn.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    dayBtn.selected = YES;
    self.selectBtn = dayBtn;
    
//    dayBtn.layer.cornerRadius = dayBtn.frame.size.height / 2;
//    dayBtn.layer.masksToBounds = YES;
//    [dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [dayBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    [dayBtn setBackgroundColor:self.dateColor];
//    [dayBtn setBackgroundImage:self.dateBG forState:UIControlStateNormal];
    CGRect frame=dayBtn.frame;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 16)];
    imageView.image = self.dateBG;
    [dayBtn addSubview:imageView];
    [dayBtn sendSubviewToBack:imageView];
    NSInteger day = dayBtn.tag;//[[dayBtn tagForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
    
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    //[btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIView *domView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width / 2 - 3, btn.frame.size.height - 6, 6, 6)];
            domView.backgroundColor = [UIColor orangeColor];
            domView.layer.cornerRadius = 3;
            domView.layer.masksToBounds = YES;
            [btn addSubview:domView];
        }
    }
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = [UIColor blueColor];
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
}

- (void)setStyle_Today:(UIButton *)btn
{
    CGRect frame=btn.frame;
    frame.origin.x=frame.origin.x+1;
    frame.origin.y=frame.origin.y+1;
    frame.size.width=btn.frame.size.width-2;
    frame.size.height=btn.frame.size.height-2;
//    btn.frame=frame;
//    
//    btn.layer.cornerRadius = btn.frame.size.height / 2;
//    btn.layer.masksToBounds = YES;
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitle:@"今天" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    
//    [btn addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, frame.size.width, 10)];
    label.text = @"今天";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColorHex(@"9b1b1b");
    [btn addSubview:label];
    btn.selected = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 16)];
    imageView.image = self.dateBG;
    [btn addSubview:imageView];
    [btn sendSubviewToBack:imageView];
//    [btn setBackgroundImage:self.dateBG forState:UIControlStateNormal];
    self.selectBtn = btn;
//    if (self.allDaysArr.count>0) {
//        if ([self.allDaysArr[btn.tag-1] integerValue]==1||
//            [self.allDaysArr[btn.tag-1] integerValue]==2||
//            [self.allDaysArr[btn.tag-1] integerValue]==3) {
//            if ([self.allDaysArr[btn.tag-1] integerValue]==2) {
//                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//            }else{
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            }
//        }else{
//            [btn setBackgroundColor:[UIColor lightGrayColor]];
//        }
//    }else{
//        [btn setBackgroundColor:[UIColor lightGrayColor]];
//    }
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    int a=0;
    
    NSString *title = btn.titleLabel.text;
    
    for (NSDictionary *dict in self.allDaysArr) {
        
        NSString *str = [NSString stringWithFormat:@"%@",dict[@"status"]];
        //        if ((a+1)==[btn.titleLabel.text integerValue]) {
        if ([title isEqualToString:[NSString stringWithFormat:@"%@",dict[@"date"]]]) {
            
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + 10, btn.frame.origin.y + 10, btn.frame.size.width - 20, btn.frame.size.height - 20)];
            stateView.layer.cornerRadius = stateView.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            //            stateView.backgroundColor = self.allDaysColor;
            stateView.image = self.allDaysImage;
            stateView.alpha = 0.9;
            /*
             0-	状况不佳
             1-	状况一般
             2-	状况良好
             3-	有记录
             4- 没有记录
             */
            stateView.backgroundColor=[UIColor clearColor];
            if ([str isEqualToString:@"0"]) {
                stateView.backgroundColor = UIColorHex(@"ff7d50");
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([str isEqualToString:@"1"]) {
                stateView.backgroundColor = UIColorHex(@"ffb434");
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([str isEqualToString:@"2"]){
                stateView.backgroundColor = UIColorHex(@"41d07d");
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else if ([str isEqualToString:@"3"]){
                stateView.layer.borderColor = BarColor.CGColor;
                stateView.layer.borderWidth = 1;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            //            [btn addSubview:stateView];
            [self addSubview:stateView];
            [self bringSubviewToFront:btn];
        }
        a++;
    }

    NSLog(@"%d",a);
    
//    for (NSString *str in self.partDaysArr) {
//        if ([str isEqualToString:btn.titleLabel.text]) {
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
////            stateView.backgroundColor = self.partDaysColor;
//            stateView.layer.borderWidth=0.9f;
//            stateView.layer.borderColor= self.partDaysColor.CGColor;
//            stateView.image = self.partDaysImage;
//            stateView.alpha = 0.9;
//            //            [btn addSubview:stateView];
//            [self addSubview:stateView];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self bringSubviewToFront:btn];
//        }
//    }
//    
//    a=0;
//    for (NSString *str in self.scoreDaysArr) {
//        if ((a+1)==[btn.titleLabel.text integerValue]&&
//            [self.scoreDaysArr[a] isEqualToString:@"1"]) {
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            //            stateView.backgroundColor = self.partDaysColor;
//            stateView.layer.borderWidth=0.9f;
//            stateView.layer.borderColor= self.partDaysColor.CGColor;
//            stateView.image = self.partDaysImage;
//            stateView.alpha = 0.9;
//            //            [btn addSubview:stateView];
//            [self addSubview:stateView];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self bringSubviewToFront:btn];
//        }
//        a++;
//    }
//    for (NSString *str in self.scoreDaysArr) {
//        if ([str isEqualToString:@"1"]) {
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            //            stateView.backgroundColor = self.partDaysColor;
//            stateView.layer.borderWidth=0.9f;
//            stateView.layer.borderColor= self.partDaysColor.CGColor;
//            stateView.image = self.partDaysImage;
//            stateView.alpha = 0.9;
//            //            [btn addSubview:stateView];
//            [self addSubview:stateView];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self bringSubviewToFront:btn];
//        }
//    }
}




#pragma mark - Lazy loading
- (NSArray *)allDaysArr {
    if (!_allDaysArr) {
        _allDaysArr = [NSArray array];
    }
    return _allDaysArr;
}

- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }
    return _partDaysArr;
}

- (NSArray *)scoreDaysArr {
    if (!_scoreDaysArr) {
        _scoreDaysArr = [NSArray array];
    }
    return _scoreDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor orangeColor];
    }
    return _headColor;
}

- (UIColor *)dateColor {
    if (!_dateColor) {
        _dateColor = [UIColor orangeColor];
    }
    return _dateColor;
}

- (UIColor *)allDaysColor {
    if (!_allDaysColor) {
        _allDaysColor = [UIColor redColor];
    }
    return _allDaysColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor greenColor];
    }
    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor lightGrayColor];
    }
    return _weekDaysColor;
}

//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
