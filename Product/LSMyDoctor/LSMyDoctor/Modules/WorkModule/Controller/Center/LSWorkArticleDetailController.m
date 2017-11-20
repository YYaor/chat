//
//  LSWorkArticleDetailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleDetailController.h"

@interface LSWorkArticleDetailController ()

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LSWorkArticleDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataDic = [NSMutableDictionary dictionary];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"文章详情";
    
    self.titleLab.text = self.dataDic[@"title"];
    
    self.infoLab.text = [NSString stringWithFormat:@"%@ %@", self.dataDic[@"doctor_name"], self.dataDic[@"create_time"]];
    
    if ([self.dataDic[@"isCollect"] longValue] == 1)
    {
        [self.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    else
    {
        [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, self.dataDic[@"url"]]]];
    
    [self.webView loadRequest:request];
}

- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[NSNumber numberWithLong:[self.dic[@"id"] longValue]] forKey:@"id"];
    
    NSString *url = PATH(@"%@/getArticleInfo");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.dataDic removeAllObjects];
            [self.dataDic addEntriesFromDictionary:responseObj[@"data"]];
            [self initForView];
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

- (IBAction)collectBtnClick:(UIButton *)btn
{
    NSString *url = nil;
    
    if ([self.dataDic[@"isCollect"] longValue] == 1)
    {
        //已收藏 取消收藏
        url = PATH(@"%@/cancelCollectArticle");
    }
    else
    {
        url = PATH(@"%@/collectArticle");
    }
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[NSNumber numberWithLong:[self.dic[@"id"] longValue]] forKey:@"id"];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
//            [self.dataDic removeAllObjects];
//            [self.dataDic addEntriesFromDictionary:responseObj[@"data"]];
//            [self initForView];
            [self requestData];
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

@end
