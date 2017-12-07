//
//  LSMineFoundController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineFoundController.h"

#import "LSWorkArticleDetailController.h"

#import "LSWorkArticleCell.h"

@interface LSMineFoundController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) WFSegTitleView *titleView;

@property (nonatomic, strong) NSMutableArray *content;

@end

@implementation LSMineFoundController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"发现";
    
    self.content = [NSMutableArray array];
    
    self.titleView = [[WFSegTitleView alloc] initWithItems:@[@"好友动态", @"资讯"]];
    self.titleView.numOfScreenW = 2;
    self.titleView.frame = CGRectMake(0, 0, LSSCREENWIDTH, 50);
    self.titleView.showLine = YES;
    [self.titleView addTarget:self action:@selector(segTap:)];
    [self.view addSubview:self.titleView];
    
    [self.tableView registerClass:[LSWorkArticleCell class] forCellReuseIdentifier:@"cell"];
}

- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    
    NSString *url = @"";
    
    if (self.titleView.selectedSegmentIndex == 0)
    {
        //getFriendArticleList 好友动态
        url = PATH(@"%@/getFriendArticleList");
    }
    else if (self.titleView.selectedSegmentIndex == 1)
    {
        //collectArticleList 咨询
        url = PATH(@"%@/getArticleList");
    }
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.content removeAllObjects];
            [self.content addObjectsFromArray:responseObj[@"data"][@"content"]];            
            [self.tableView reloadData];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

-(void)segTap:(WFSegTitleView*)seg
{
    [self requestData];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSWorkArticleDetailController *vc = [[LSWorkArticleDetailController alloc] initWithNibName:@"LSWorkArticleDetailController" bundle:nil];
    vc.dic = self.content[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setDataWithDictionary:self.content[indexPath.section] type:@"2"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *data = self.content[indexPath.section];
    if ([data[@"type"] integerValue] == 4) {
        return 150;
    }else{
        return self.view.frame.size.width/3 + 150;
    }
}

@end
