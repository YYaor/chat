//
//  LSWorkActivityController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityController.h"

#import "LSWorkActivityAddController.h"
#import "LSWorkActivityDetailController.h"

#import "LSWorkActivityCell.h"

static NSString *cellId = @"LSWorkActivityCell";

@interface LSWorkActivityController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *content;

@end

@implementation LSWorkActivityController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"活动管理";
    
    self.content = [NSMutableArray array];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.estimatedRowHeight =100000;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}

- (void)rightItemClick
{
    LSWorkActivityAddController *vc = [[LSWorkActivityAddController alloc] initWithNibName:@"LSWorkActivityAddController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    
    NSString *url = PATH(@"%@/getMyActivityList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.content removeAllObjects];
            NSArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"saveactivity" WithPath:@"activity"];
            if (saveArr) {
                [self.content addObjectsFromArray:saveArr];
            }
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *data =self.content[indexPath.section];
    if ([data[@"savetime"] doubleValue] > 0) {
        //草稿进入
        LSWorkActivityAddController *vc = [[LSWorkActivityAddController alloc] initWithNibName:@"LSWorkActivityAddController" bundle:nil];
        vc.data = data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LSWorkActivityDetailController *vc = [[LSWorkActivityDetailController alloc] initWithNibName:@"LSWorkActivityDetailController" bundle:nil];
        vc.dic = data;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma makr - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell setDataWithDictionary:self.content[indexPath.section]];
    cell.deleteBlock = ^(NSDictionary *dataDic) {
        
        if (dataDic[@"status"])
        {
            //不是草稿
            NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
            
            [param setObject:[NSNumber numberWithInteger:[dataDic[@"id"] integerValue]] forKey:@"id"];
            NSString * url = PATH(@"%@/deleteActivity");
            [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
                
                if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
                {
                    [self requestData];
                    [XHToast showCenterWithText:@"删除成功"];
                    
                }else
                {
                    [XHToast showCenterWithText:responseObj[@"message"]];
                }
            } failBlock:^(NSError *error) {
                //[XHToast showCenterWithText:@"fail"];
            }];
        }
        else
        {
            //是草稿是就本地删除
            NSMutableArray *tempArr = [LSCacheManager unarchiverObjectByKey:@"saveactivity" WithPath:@"activity"];
            
            NSMutableArray *saveArr = [NSMutableArray array];
            for (NSDictionary *dic in tempArr) {
                if ([self.content[indexPath.section][@"savetime"] doubleValue] != [dic[@"savetime"] doubleValue]) {
                    [saveArr addObject:dic];
                }
            }
            
            [[LSCacheManager sharedInstance] removeObjectWithFilePath:@"activity"];
            [[LSCacheManager sharedInstance] archiverObject:saveArr ByKey:@"saveactivity" WithPath:@"activity"];
            
            [self.content removeObject:dataDic];
            [self.tableView reloadData];
            [XHToast showCenterWithText:@"删除成功"];
        }
    };
    return cell;
}

@end
