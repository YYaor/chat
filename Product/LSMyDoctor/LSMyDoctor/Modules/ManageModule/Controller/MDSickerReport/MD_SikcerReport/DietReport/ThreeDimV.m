//
//  ThreeDimV.m
//  new
//
//  Created by yunzujia on 16/10/25.
//  Copyright © 2016年 yunzujia. All rights reserved.
//
#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]

#import "ThreeDimV.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThreeDimV
{
    UILabel * titleL;      //三餐均衡
    
    UIView * bg1;          //标准值线条
    UIView * bg2;          //您的值线条
    UILabel * countlabs;   //标准值lab
    UILabel * countlabp;   //您的值lab
    
    UILabel * breLab;      //早餐
    UILabel * brelabS;     //早餐标准
    UILabel * brelabp;     //早餐自己
    
    UILabel * lunlab;
    UILabel * lunlabs;
    UILabel * lunlabp;
    
    UILabel * dilab;
    UILabel * dilabs;
    UILabel * dilabp;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.standardx = 30;
        self.standardy = 100;
        self.standardz = 30;
        
        self.x = 70;
        self.y = 30;
        self.z = 20;
        [self setNeedsDisplay];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat ceterY = self.bounds.size.height/5.0*3.0;
    CGFloat longxyz = 150 * kScreenWidth * 1.0 / 320;
    
    // 设置背景色
    self.backgroundColor = [UIColor whiteColor];

    //设置坐标轴线
    UIColor *color = kColorWithRGB(0xa0, 0xa0, 0xa0);
    [color set];
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;   //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    //z轴
    [aPath moveToPoint:CGPointMake(self.center.x, ceterY)];
    [aPath addLineToPoint:CGPointMake(self.center.x, ceterY - longxyz)];
    [aPath closePath];
    [aPath stroke];
    
    //y轴
    [aPath moveToPoint:CGPointMake(self.center.x, ceterY)];
    [aPath addLineToPoint:CGPointMake(self.center.x - longxyz/2.0 / tan(M_PI / 6), ceterY + longxyz/2.0)];
    [aPath closePath];
    
    //x轴
    [aPath moveToPoint:CGPointMake(self.center.x, ceterY)];
    [aPath addLineToPoint:CGPointMake(self.center.x + longxyz/2.0 / tan(M_PI / 6), ceterY + longxyz/2.0)];
    [aPath closePath];
    [aPath stroke];
    
//／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／

    //标准值
    UIColor *color1 = kColorWithRGB(0x86, 0xB9, 0xFF);
    [color1 set];
    UIBezierPath* aPath1 = [UIBezierPath bezierPath];
    aPath1.lineWidth = 2.0;
    aPath1.lineCapStyle = kCGLineCapRound;   //线条拐角
    aPath1.lineJoinStyle = kCGLineCapRound;  //终点处理
    [aPath1 moveToPoint:CGPointMake(self.center.x, ceterY - self.standardz*longxyz/100)];//z
    [aPath1 addLineToPoint:CGPointMake(self.center.x - self.standardy*longxyz/100/2.0 / tan(M_PI / 6), ceterY+ self.standardy*longxyz/100/2.0)];//y
    [aPath1 addLineToPoint:CGPointMake(self.center.x + self.standardx*longxyz/100/2.0/tan(M_PI/6), ceterY+self.standardx*longxyz/100/2.0f)];
    [aPath1 addLineToPoint:CGPointMake(self.center.x, ceterY - self.standardz*longxyz/100)];
    [aPath1 stroke];
    

//／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    //实际值--画线
    UIColor * color2 = kColorWithRGB(0xFF, 0xB4, 0x34);
    [color2 set];
    UIBezierPath* aPath2 = [UIBezierPath bezierPath];
    aPath2.lineWidth = 2.0;
    aPath2.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath2.lineJoinStyle = kCGLineCapRound;  //终点处理
    [aPath2 moveToPoint:CGPointMake(self.center.x, ceterY-self.z*longxyz/100)];
    [aPath2 addLineToPoint:CGPointMake(self.center.x - self.y*longxyz/100/2.0/tan(M_PI/6), ceterY+self.y*longxyz/100/2.0)];
    [aPath2 addLineToPoint:CGPointMake(self.center.x+self.x*longxyz/100/2.0/tan(M_PI/6), ceterY+self.x*longxyz/100/2.0f)];
    [aPath2 addLineToPoint:CGPointMake(self.center.x, ceterY-self.z*longxyz/100)];
    [aPath2 stroke];
    
//／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／／
    for (int i = 0; i < 3; i ++)
    {
        //用户值得圆点
        UIView * v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        v1.layer.masksToBounds = YES;
        v1.layer.cornerRadius = 4;
        v1.backgroundColor =  kColorWithRGB(79, 150, 255);
        switch (i) {
            case 0:
                v1.center = CGPointMake(self.center.x, ceterY - self.standardz*longxyz/100);
                break;
            case 1:
                v1.center = CGPointMake(self.center.x - self.standardy*longxyz/100/2.0 / tan(M_PI / 6), ceterY+ self.standardy*longxyz/100/2.0);
                break;
            default:
                v1.center = CGPointMake(self.center.x + self.standardx*longxyz/100/2.0/tan(M_PI/6), ceterY+self.standardx*longxyz/100/2.0f);
                break;
        }
        [self addSubview:v1];
    }
    
    for (int j = 0; j < 3; j ++)
    {
        //标准值的圆点
        UIView * v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        v2.layer.masksToBounds = YES;
        v2.layer.cornerRadius = 4;
        v2.backgroundColor = kColorWithRGB(252, 152, 46);
        switch (j) {
            case 0:
                v2.center = CGPointMake(self.center.x, ceterY-self.z*longxyz/100);
                break;
             case 1:
                v2.center = CGPointMake(self.center.x - self.y*longxyz/100/2.0/tan(M_PI/6), ceterY+self.y*longxyz/100/2.0);
                break;
            default:
                v2.center = CGPointMake(self.center.x+self.x*longxyz/100/2.0/tan(M_PI/6), ceterY+self.x*longxyz/100/2.0f);
                break;
        }
        [self addSubview:v2];
    }
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    titleL.font = [UIFont systemFontOfSize:24];
    titleL.textColor = Style_Color_Content_Blue;
    titleL.text = @"三餐均衡";
//    titleL.hidden = YES;
    [self addSubview:titleL];
    
    bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
    bg1.backgroundColor = kColorWithRGB(79, 150, 255);
    [self addSubview:bg1];
    
    bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
    bg2.backgroundColor = kColorWithRGB(252, 152, 46);
    [self addSubview:bg2];
    
    countlabs = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    countlabs.font = [UIFont systemFontOfSize:16];
    countlabs.textColor = kColorWithRGB(0x21, 0x21, 0x21);
    countlabs.text = @"标准值";
    [self addSubview:countlabs];
    
    countlabp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    countlabp.font = [UIFont systemFontOfSize:16];
    countlabp.textColor = kColorWithRGB(0x21, 0x21, 0x21);
    countlabp.text = @"您的值";
    [self addSubview:countlabp];
    
    breLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    //breLab.text = @"早餐";
    breLab.font = [UIFont systemFontOfSize:16];
    breLab.textColor = kColorWithRGB(0x21, 0x21, 0x21);
    breLab.text = self.namez;
    [self addSubview:breLab];
    
    brelabS = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    brelabS.font = [UIFont systemFontOfSize:16];
    brelabS.textColor = kColorWithRGB(0x86, 0xB9, 0xFF);
    brelabS.text = [NSString stringWithFormat:@"%d%@", (int)self.standardz, @"%"];
    [self addSubview:brelabS];
    
    brelabp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    brelabp.font = [UIFont systemFontOfSize:16];
    brelabp.textColor = kColorWithRGB(0xFF, 0xB4, 0x34);
    brelabp.text = [NSString stringWithFormat:@"%d%@", (int)self.z, @"%"];
    [self addSubview:brelabp];

    lunlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    //lunlab.text = @"午餐";
    lunlab.font = [UIFont systemFontOfSize:16];
    lunlab.textColor = kColorWithRGB(0x21, 0x21, 0x21);
    lunlab.text = self.namey;
    [self addSubview:lunlab];
    
    lunlabs = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lunlabs.font = [UIFont systemFontOfSize:16];
    lunlabs.textColor = kColorWithRGB(0x86, 0xB9, 0xFF);
    lunlabs.text = [NSString stringWithFormat:@"%d%@", (int)self.standardy, @"%"];
    [self addSubview:lunlabs];
    
    lunlabp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lunlabp.font = [UIFont systemFontOfSize:16];
    lunlabp.textColor = kColorWithRGB(0xFF, 0xB4, 0x34);
    lunlabp.text = [NSString stringWithFormat:@"%d%@", (int)self.y, @"%"];
    [self addSubview:lunlabp];
    
    dilab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    dilab.font = [UIFont systemFontOfSize:16];
    dilab.textColor = kColorWithRGB(0x21, 0x21, 0x21);
    //dilab.text = @"晚餐";
    dilab.text = self.namex;
    [self addSubview:dilab];
    
    dilabs = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    dilabs.font = [UIFont systemFontOfSize:16];
    dilabs.textColor = kColorWithRGB(0x86, 0xB9, 0xFF);
    dilabs.text = [NSString stringWithFormat:@"%d%@", (int)self.standardx, @"%"];
    [self addSubview:dilabs];
    
    dilabp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    dilabp.font = [UIFont systemFontOfSize:16];
    dilabp.textColor = kColorWithRGB(0xFF, 0xB4, 0x34);
    dilabp.text = [NSString stringWithFormat:@"%d%@", (int)self.x, @"%"];
    [self addSubview:dilabp];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(10);
    }];
    
    [countlabs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.top.equalTo(self).with.offset(20);
    }];
    
    [bg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countlabs);
        make.right.equalTo(countlabs.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 4));
    }];
    
    [countlabp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countlabs.mas_bottom).with.offset(5);
        make.right.equalTo(self).with.offset(-20);
    }];
    
    [bg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countlabp);
        make.right.equalTo(countlabp.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 4));
    }];
    
    breLab.frame = CGRectMake(self.center.x - 45, ceterY - longxyz, 60, 30) ;
    [brelabS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(breLab.mas_bottom).with.offset(-6);
        make.leading.equalTo(breLab.mas_leading);
    }];
    [brelabp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brelabS.mas_bottom).with.offset(-5);
        make.leading.equalTo(brelabS.mas_leading);
    }];
    
    lunlab.frame = CGRectMake(self.center.x - longxyz/2.0/tan(M_PI/6.0), ceterY + longxyz/2.0 - 80, 60, 30);
    [lunlabs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lunlab.mas_bottom).with.offset(-6);
        make.leading.equalTo(lunlab.mas_leading);
    }];
    [lunlabp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lunlabs.mas_bottom).with.offset(-5);
        make.leading.equalTo(lunlabs.mas_leading);
    }];
    
    dilab.frame = CGRectMake(self.center.x + longxyz/2.0/tan(M_PI/6.0)- 30, ceterY + longxyz/2.0 - 80, 60, 30);
    [dilabs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dilab.mas_bottom).with.offset(-6);
        make.leading.equalTo(dilab.mas_leading);
    }];
    [dilabp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dilabs.mas_bottom).with.offset(-5);
        make.leading.equalTo(dilabs.mas_leading);
    }];
    
}
@end
