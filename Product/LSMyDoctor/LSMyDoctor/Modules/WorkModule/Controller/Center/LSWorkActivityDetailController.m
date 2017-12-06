//
//  LSWorkActivityDetailController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/12/1.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkActivityDetailController.h"

#import "LSWorkActivityDetailCell1.h"
#import "LSWorkActivityDetailCell2.h"

static NSString *cell1Id = @"LSWorkActivityDetailCell1";
static NSString *cell2Id = @"LSWorkActivityDetailCell2";

@interface LSWorkActivityDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) UILabel *footer;

@end

@implementation LSWorkActivityDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cell1Id bundle:nil] forCellReuseIdentifier:cell1Id];
    [self.tableView registerNib:[UINib nibWithNibName:cell2Id bundle:nil] forCellReuseIdentifier:cell2Id];
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = self.footer;
    
    self.dataDic = [NSMutableDictionary dictionary];
    
    [self requestData];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"活动详情";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.titleLab.text = self.dataDic[@"name"];
    self.infoLab.text = [NSString stringWithFormat:@"%@ %@", self.dataDic[@"doctor_name"], self.dataDic[@"create_time"]];
    
    self.footer.text = [NSString stringWithFormat:@"   已报名：%ld/%ld", [self.dataDic[@"sign_number"] longValue], [self.dataDic[@"total_number"] longValue]];
    
    [self.tableView reloadData];
}


- (void)requestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[NSNumber numberWithLong:[self.dic[@"id"] longValue]] forKey:@"id"];
    
    NSString *url = PATH(@"%@/getActivityInfo");
    
    
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

- (void)rightItemClick
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@"2" forKey:@"type"];//1文章分享 2活动分享 3名片分享
    
    NSString *url = PATH(@"%@/share");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSMutableDictionary *paramInfo = [NSMutableDictionary dictionary];
            [paramInfo setValue:self.dataDic[@"name"] forKey:@"title"];
            [paramInfo setValue:self.dataDic[@"content"] forKey:@"content"];
            [paramInfo setValue:self.dataDic[@"share_url"] forKey:@"url"];
            
            [LSShareTool showShareToolParams:paramInfo type:param[@"type"]];
            
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataDic[@"img_url"])
    {
        return 4;
    }
    else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataDic[@"img_url"])
    {
        if (indexPath.row == 0)
        {
            LSWorkActivityDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell1Id forIndexPath:indexPath];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"img_url"]]];
            return cell;
        }
        else
        {
            LSWorkActivityDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cell2Id forIndexPath:indexPath];
            if (indexPath.row == 1)
            {
                cell.titleLab.text = @"活动内容";
                cell.subTitleLab.text = self.dataDic[@"content"];
            }
            else if (indexPath.row == 2)
            {
                cell.titleLab.text = @"活动地址";
                cell.subTitleLab.text = self.dataDic[@"address"];
            }
            else
            {
                cell.titleLab.text = @"活动时间";
                cell.subTitleLab.text = self.dataDic[@"activity_time"];
            }
            return cell;
        }
    }
    else
    {
        LSWorkActivityDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cell2Id forIndexPath:indexPath];
        if (indexPath.row == 0)
        {
            cell.titleLab.text = @"活动内容";
            cell.subTitleLab.text = self.dataDic[@"content"];
        }
        else if (indexPath.row == 1)
        {
            cell.titleLab.text = @"活动地址";
            cell.subTitleLab.text = self.dataDic[@"address"];
        }
        else
        {
            cell.titleLab.text = @"活动时间";
            cell.subTitleLab.text = self.dataDic[@"activity_time"];
        }
        return cell;
    }
   
}

- (UILabel *)footer
{
    if (!_footer)
    {
        _footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _footer.font = [UIFont systemFontOfSize:14];
    }
    return _footer;
}

@end
