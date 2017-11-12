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
@property (nonatomic, strong) NSMutableArray *allBtns;//所有的btns

@end

@implementation LSWorkArticleSubController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [NSMutableArray array];
    self.selBtns = [NSMutableArray array];
    self.allBtns = [NSMutableArray array];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"发布设置";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-80)];
    [self.view addSubview:scrollView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, CGRectGetMaxY(scrollView.frame)+20, [UIScreen mainScreen].bounds.size.width-40, 40);
    [sureBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    sureBtn.layer.cornerRadius = 20;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 80, 20)];
    lab1.text = @"疾病人群";
    [scrollView addSubview:lab1];
    
    CGFloat btnWidth = 90;
    CGFloat btnHeight = 50;
    CGFloat spaceWidth = ([UIScreen mainScreen].bounds.size.width-40-3*btnWidth)/2;
    CGFloat spaceHeight = 20;
    
    CGFloat lastBtnMaxY = CGRectGetMaxY(lab1.frame);
    
    for (NSInteger i=0; i<self.dataList.count; i++)
    {
        NSInteger col = i%3;
        NSInteger row = i/3;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+col*(btnWidth+spaceWidth), CGRectGetMaxY(lab1.frame)+spaceHeight+row*(btnHeight+spaceHeight), btnWidth, btnHeight);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        btn.layer.cornerRadius = btnHeight/2;
        [btn setTitle:self.dataList[i][@"label_text"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.allBtns addObject:btn];
        
        lastBtnMaxY = CGRectGetMaxY(btn.frame);
    }
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(20, lastBtnMaxY+20, [UIScreen mainScreen].bounds.size.width-40, 1)];
    vi.backgroundColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR];
    [scrollView addSubview:vi];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(vi.frame)+20, 80, 20)];
    lab2.text = @"发送时间";
    [scrollView addSubview:lab2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, CGRectGetMaxY(lab2.frame)+spaceHeight, btnWidth, btnHeight);
    btn.layer.cornerRadius = btnHeight/2;
    [btn setTitle:@"立即发送" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    [scrollView addSubview:btn];
    
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(btn.frame)+20);
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
                [weakSelf.dataList addObject:@{@"label_text":@"全部", @"label_code":@"0"}];
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
        [self.selBtns removeObject:btn];
    }
    else
    {
        [self.selBtns addObject:btn];
    }
    
    if ([btn.titleLabel.text isEqualToString:@"全部"])
    {
        [self.selBtns removeAllObjects];
        [self.selBtns addObject:btn];
    }
    else
    {
        NSArray *tempArr = [self.selBtns copy];
        for (UIButton *tBtn in tempArr)
        {
            if ([tBtn.titleLabel.text isEqualToString:@"全部"])
            {
                [self.selBtns removeObject:tBtn];
            }
        }
    }
    
    //reset btns
    for (UIButton *defBtn in self.allBtns)
    {
        defBtn.selected = NO;
        defBtn.layer.borderWidth = 1;
        [defBtn setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    for (UIButton *selBtn in self.selBtns)
    {
        selBtn.selected = YES;
        selBtn.layer.borderWidth = 0;
        [selBtn setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    }
    
}

- (void)sureBtnClick
{
    //发布
//    /dr/addArticle
//    请求参数列表
//    变量名	含义	类型	备注
//    classify	文章分类	string
//    content	文章内容	string
//    cookie	医生cookie	string
//    disease_group	患者疾病分类	string	常用标签、全部传空，多个以“、”分隔
//    img_url	文章图像地址	string
//    keyword	文章关键字	string
//    title	文章标题	string
    if (self.selBtns.count==0)
    {
        [XHToast showCenterWithText:@"请先选择疾病人群"];
        return;
    }
    
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.infoDic[@"title"] forKey:@"title"];//文章标题	string
    [param setValue:self.infoDic[@"keyword"] forKey:@"keyword"];//文章关键字	string
    [param setValue:self.infoDic[@"classify"] forKey:@"classify"];//文章分类	string
    [param setValue:self.infoDic[@"content"] forKey:@"content"];//文章内容	string
    
    if (self.infoDic[@"img_url"])
    {
        [param setValue:self.infoDic[@"img_url"] forKey:@"img_url"];//文章图像地址	string
    }
    
    NSString *disease_group = @"";
    
    for (NSInteger i=0; i<self.selBtns.count; i++)
    {
        UIButton *btn = self.selBtns[i];
        
        if (![btn.titleLabel.text isEqualToString:@"全部"])
        {
            if (i==0)
            {
                for (NSDictionary *dic in self.dataList)
                {
                    if ([dic[@"label_text"] isEqualToString:btn.titleLabel.text])
                    {
                        disease_group = [disease_group stringByAppendingString:[NSString stringWithFormat:@"%ld", [dic[@"label_code"] longValue]]];
                        break;
                    }
                }
            }
            else
            {
                for (NSDictionary *dic in self.dataList)
                {
                    if ([dic[@"label_text"] isEqualToString:btn.titleLabel.text])
                    {
                        disease_group = [disease_group stringByAppendingString:[NSString stringWithFormat:@",%ld", [dic[@"label_code"] longValue]]];
                        break;
                    }
                }
            }
        }
    }
    
    if (![disease_group isEqualToString:@""])
    {
        [param setValue:disease_group forKey:@"disease_group"];
    }

    NSString* url = PATH(@"%@/addArticle");

    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {

        if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {

                [XHToast showCenterWithText:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];

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

@end
