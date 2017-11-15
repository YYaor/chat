//
//  LSRecommendArticleController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/15.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSRecommendArticleController.h"

#import "LSRecommendArticleCell.h"

static NSString *cellId = @"LSRecommendArticleCell";

@interface LSRecommendArticleController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation LSRecommendArticleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"选择推荐的文章";
    
    self.dataList = [NSMutableArray array];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 90;
}

- (void)rightItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    
    NSString *url = PATH(@"%@/collectArticleList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSArray *array = responseObj[@"data"][@"content"];
            
            for (NSDictionary *dic in array)
            {
                LSRecommendArticleModel *model = [LSRecommendArticleModel new];
                model.title = dic[@"title"];
                model.content = dic[@"content"];
                model.isSel = NO;
                model.m_id = [dic[@"id"] longValue];
                [self.dataList addObject:model];
            }
            
            [weakSelf.tableView reloadData];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"");
    }];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //reset
    
    for (NSInteger i=0; i<self.dataList.count; i++)
    {
        LSRecommendArticleModel *reModel = self.dataList[i];
        reModel.isSel = NO;
        [self.dataList replaceObjectAtIndex:i withObject:reModel];
    }
    
    LSRecommendArticleModel *model = self.dataList[indexPath.row];
    model.isSel = YES;
    [self.dataList replaceObjectAtIndex:indexPath.row withObject:model];
    
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSRecommendArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell setDataWithModel:self.dataList[indexPath.row]];
    return cell;
}

@end
