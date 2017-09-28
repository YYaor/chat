//
//  LSWorkController.m
//  LSKJChart
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkController.h"

//top
#import "LSWorkUnreplyController.h"
#import "LSWorkAppointController.h"
#import "LSWorkTailController.h"
#import "LSWorkAdviceController.h"

//center
#import "LSWorkOutcallController.h"

//bottom


@interface LSWorkController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSArray *topTitleArr;
@property (nonatomic, strong) NSArray *topImageArr;
@property (nonatomic, strong) NSArray *topColorArr;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSArray *centerTitleArr;
@property (nonatomic, strong) NSArray *centerImageArr;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSArray *bottomTitleArr;
@property (nonatomic, strong) NSArray *bottomImageArr;
@property (nonatomic, strong) NSArray *bottomColorArr;

@end

@implementation LSWorkController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"工作台";
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scanItemClick)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, 95)];
    topView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
    [self.view addSubview:topView];
    
    [self.view addSubview:self.scrollView];
    
    self.topTitleArr = @[@"待回复", @"预约提醒", @"医嘱跟踪", @"患者请求"];
    self.topImageArr = @[@"tobeanswer", @"time_white", @"doctoradvice", @"patientrequest"];
    self.topColorArr = @[LSPURPLECOLOR, LSPINKCOLOR, LSYELLOWCOLOR, LSBLUECOLOR];
    [self.scrollView addSubview:self.topView];
    
    self.centerTitleArr = @[@"出诊记录", @"文章管理", @"活动管理", @"常用语管理", @"数据统计"];
    self.centerImageArr = @[@"outgoingrecords", @"patienthistory", @"activitymanagement", @"commonlanguagemanagement", @"datastatistics"];
    [self.scrollView addSubview:self.centerView];

    self.bottomTitleArr = @[@"待回复同行", @"同行请求", @"同行管理"];
    self.bottomImageArr = @[@"Peetoreply", @"Peer-request", @"mypeers"];
    self.bottomColorArr = @[LSGREENCOLOR, LSPINKCOLOR, LSBLUECOLOR];
    [self.scrollView addSubview:self.bottomView];
    
    self.scrollView.contentSize = CGSizeMake(LSSCREENWIDTH, CGRectGetMaxY(self.bottomView.frame)+20);
}

- (void)scanItemClick
{
    
}

- (void)topBtnClick:(UIButton *)btn
{
    if (btn.tag == 10000)
    {
        //待回复
        LSWorkUnreplyController *vc = [[LSWorkUnreplyController alloc] initWithNibName:@"LSWorkUnreplyController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 10001)
    {
        //预约提醒
        LSWorkAppointController *vc = [[LSWorkAppointController alloc] initWithNibName:@"LSWorkAppointController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 10002)
    {
        //医嘱跟踪
        
        LSWorkTailController *vc = [[LSWorkTailController alloc] initWithNibName:@"LSWorkTailController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 10003)
    {
        //患者请求
        LSWorkAdviceController *vc = [[LSWorkAdviceController alloc] initWithNibName:@"LSWorkAdviceController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)centerBtnClick:(UIButton *)btn
{
    if (btn.tag == 20000)
    {
        //出诊记录
        LSWorkOutcallController *vc = [[LSWorkOutcallController alloc] initWithNibName:@"LSWorkOutcallController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (btn.tag == 20001)
    {
        //文章管理
    }
    else if (btn.tag == 20002)
    {
        //活动管理
    }
    else if (btn.tag == 20003)
    {
        //常用语管理
    }
    else if (btn.tag == 20004)
    {
        //数据统计
    }
}

- (void)bottomBtnClick:(UIButton *)btn
{
    if (btn.tag == 30000)
    {
        //待回复同行
    }
    else if (btn.tag == 30001)
    {
        //同行请求
    }
    else if (btn.tag == 30002)
    {
        //同行管理
    }
}

#pragma mark - getter & setter

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT-64-49)];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, LSSCREENWIDTH-40, 170)];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.cornerRadius = 10;
        _topView.layer.borderWidth = 1;
        _topView.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        
        NSInteger count = self.topTitleArr.count;
        CGFloat btnWidth = 60;
        CGFloat labWidth = _topView.bounds.size.width/count;
        CGFloat spaceWidth = (_topView.bounds.size.width-count*btnWidth)/(2*count);
        
        for (NSInteger i=0; i<count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(spaceWidth+(2*spaceWidth+btnWidth)*i, 40, btnWidth, btnWidth);
            [btn setImage:[UIImage imageNamed:self.topImageArr[i]] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorFromHexString:self.topColorArr[i]]];
            btn.layer.cornerRadius = btnWidth/2;
            btn.layer.borderColor = [UIColor colorFromHexString:self.topColorArr[i]].CGColor;
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+10000;
            [_topView addSubview:btn];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*labWidth, 120, labWidth, 20)];
            lab.text = self.topTitleArr[i];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
            [_topView addSubview:lab];
        }
    }
    return _topView;
}

- (UIView *)centerView
{
    if (!_centerView)
    {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20+CGRectGetMaxY(self.topView.frame), LSSCREENWIDTH-40, 215)];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 10;
        _centerView.layer.borderWidth = 1;
        _centerView.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        
        NSInteger count = self.centerTitleArr.count;
        CGFloat btnWidth = (_centerView.bounds.size.width-2)/3;
        CGFloat btnHeight = 60;
        
        for (NSInteger i=0; i<count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((1+btnWidth)*(i%3), 10+107*(i/3), btnWidth, btnHeight);
            [btn setImage:[UIImage imageNamed:self.centerImageArr[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+20000;
            [_centerView addSubview:btn];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((1+btnWidth)*(i%3), CGRectGetMaxY(btn.frame), btnWidth, 20)];
            lab.text = self.centerTitleArr[i];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
            [_centerView addSubview:lab];
        }
        
        UIView *horLine = [[UIView alloc] initWithFrame:CGRectMake(0, (_centerView.bounds.size.height-1)/2, _centerView.bounds.size.width, 1)];
        horLine.backgroundColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR];
        [_centerView addSubview:horLine];
        
        for (NSInteger i=0; i<2; i++)
        {
            UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*(i+1), 0, 1, _centerView.bounds.size.height)];
            verLine.backgroundColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR];
            [_centerView addSubview:verLine];
        }
    }
    return _centerView;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 20+CGRectGetMaxY(self.centerView.frame), LSSCREENWIDTH-40, 170)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 10;
        _bottomView.layer.borderWidth = 1;
        _bottomView.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        
        NSInteger count = self.bottomTitleArr.count;
        CGFloat btnWidth = 60;
        CGFloat labWidth = _bottomView.bounds.size.width/count;
        CGFloat spaceWidth = (_bottomView.bounds.size.width-count*btnWidth)/(2*count);
        
        for (NSInteger i=0; i<count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(spaceWidth+(2*spaceWidth+btnWidth)*i, 40, btnWidth, btnWidth);
            [btn setImage:[UIImage imageNamed:self.bottomImageArr[i]] forState:UIControlStateNormal];
            btn.layer.cornerRadius = btnWidth/2;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorFromHexString:self.bottomColorArr[i]].CGColor;
            [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+30000;
            [_bottomView addSubview:btn];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*labWidth, 120, labWidth, 20)];
            lab.text = self.bottomTitleArr[i];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [UIColor colorFromHexString:LSDARKGRAYCOLOR];
            [_bottomView addSubview:lab];
        }
    }
    return _bottomView;
}

@end
