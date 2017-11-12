//
//  LSWorkArticleSubController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/10.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleSubController.h"

@interface LSWorkArticleSubController ()

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *selBtns;//选中的btns

@end

@implementation LSWorkArticleSubController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"发布设置";
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 80, 20)];
    lab1.text = @"疾病人群";
    [self.view addSubview:lab1];
    
    CGFloat btnWidth = 80;
    CGFloat btnHeight = 60;
    CGFloat spaceWidth = ([UIScreen mainScreen].bounds.size.width-20-3*btnWidth)/2;
    CGFloat spaceHeight = 20;
    
    for (NSInteger i=0; i<self.dataList.count; i++)
    {
        NSInteger col = i%3;
        NSInteger row = i/3;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+col*(btnWidth+spaceWidth), spaceHeight+row*(btnHeight+spaceHeight), btnWidth, btnHeight);
        btn.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        btn.layer.cornerRadius = btnHeight/2;
        [btn setTitle:self.dataList[i][@"label_text"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)requestData
{
    LSWEAKSELF;
    
    //常用标签
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/getCommonLabels");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                
                [weakSelf.dataList addObjectsFromArray:responseObj[@"data"]];
                
                [weakSelf initForView];
                
            }else{
                NSLog(@"返回数据有误");
            }
        }else
        {
            [XHToast showCenterWithText:@"获取分类列表失败"];
        }
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

- (void)btnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (!btn.selected)
    {
        btn.layer.borderWidth = 1;
    }
    else
    {
        btn.layer.borderWidth = 0;
    }
}

@end
