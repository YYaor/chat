//
//  LSWorkAppointController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkAppointController.h"

#import "LSWorkAppointCell.h"

static NSString *cellId = @"LSWorkAppointCell";

@interface LSWorkAppointController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataArray;

@end

@implementation LSWorkAppointController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    [self initForView];
    [self loadData];
}

- (void)initForView
{
    self.navigationItem.title = @"预约提醒";
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    self.tableView.rowHeight = 140;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, 20)];
    self.tableView.tableFooterView = footer;
}

-(void)loadData{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    
    NSString *url = PATH(@"%@/getOrderList");
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:NO httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]])
        {
            if ([responseObj[@"status"] integerValue] == 0) {
                
                if (responseObj[@"data"]) {
                  
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:responseObj[@"data"]];
                    [self.tableView reloadData];
                    
                }
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkAppointCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}

@end
