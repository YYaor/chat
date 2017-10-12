//
//  LSWorkOutcallAddController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/8.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallAddController.h"

@interface LSWorkOutcallAddController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

//患者
@property (weak, nonatomic) IBOutlet UIView *view1;


//性别
@property (weak, nonatomic) IBOutlet UIView *view2;


//年龄
@property (weak, nonatomic) IBOutlet UIView *view3;


//主诉
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView4;


//现病史
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView5;


//诊断
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet YYPlaceholderTextView *textView6;


@end

@implementation LSWorkOutcallAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"新增记录";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateLab.text = [formatter stringFromDate:self.date];
    
    self.textView4.placeholder = @"请填写主诉内容";
    self.textView5.placeholder = @"请填写现病史";
    self.textView6.placeholder = @"请填写诊断内容";
    
    self.contentView.frame = CGRectMake(20, 40, LSSCREENWIDTH-40, 611);
    [self.scrollView addSubview:self.contentView];
    
    self.scrollView.contentSize = CGSizeMake(LSSCREENWIDTH, LSHEIGHT(self.contentView)+80);
}


@end
