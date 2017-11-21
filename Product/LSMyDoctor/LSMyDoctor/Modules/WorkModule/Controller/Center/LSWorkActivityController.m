//
//  LSWorkActivityController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityController.h"

#import "LSWorkActivityAddController.h"

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
//
//            if (self.lastBtn == self.manageBtn) {
//                NSArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"savearticle" WithPath:@"article"];
//                if (saveArr) {
//                    [weakSelf.content addObjectsFromArray:saveArr];
//                }
//                [weakSelf.content addObjectsFromArray:responseObj[@"data"][@"content"]];
//            }else{
                [self.content addObjectsFromArray:responseObj[@"data"][@"content"]];
//            }
//            
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

#pragma makr - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    [cell setDataWithDictionary:self.content[indexPath.row]];
    return cell;
}

@end
