//
//  LSWorkOutcallListController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/4.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkOutcallListController.h"

#import "LSWorkOutcallAddController.h"

#import "LSWorkOutcallListCell.h"

static NSString *cellId = @"LSWorkOutcallListCell";

@interface LSWorkOutcallListController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation LSWorkOutcallListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self initForView];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

- (void)initForView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.navigationItem.title = [formatter stringFromDate:self.date];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 120;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, 20)];
    self.tableView.tableFooterView = footer;
}

-(void)loadData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [param setObject:[formatter stringFromDate:self.date] forKey:@"visit_date"];
    NSString *url = PATH(@"%@/visitList");
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"][@"list"]) {
                    self.dataArray = responseObj[@"data"][@"list"];
                }
                [self.tableView reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemClick
{
    LSWorkOutcallAddController *vc = [[LSWorkOutcallAddController alloc] initWithNibName:@"LSWorkOutcallAddController" bundle:nil];
    vc.date = self.date;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LSWorkOutcallAddController *vc = [[LSWorkOutcallAddController alloc] initWithNibName:@"LSWorkOutcallAddController" bundle:nil];
    vc.date = self.date;
    vc.infoDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkOutcallListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}
@end
