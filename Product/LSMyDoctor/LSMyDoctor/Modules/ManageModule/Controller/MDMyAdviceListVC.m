//
//  MDMyAdviceListVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDMyAdviceListVC.h"
#import "MDMyAdviceDetailVC.h"

@interface MDMyAdviceListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* listTab;
}
@property (nonatomic,strong) NSMutableArray *listMultArr;//日期列表数组

@end

@implementation MDMyAdviceListVC
#pragma mark -- 懒加载
- (NSMutableArray *)listMultArr{
    
    if (_listMultArr == nil) {
        _listMultArr = [NSMutableArray array];
        NSArray * arr = [[NSArray alloc] initWithObjects:@"2010年10月28日",@"2011年06月03日",@"2000年04月15日",@"2016年12月28日", nil];
        [_listMultArr addObjectsFromArray:arr];
    }
    return _listMultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看医嘱";
    
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取医嘱列表
    [self getMyAdviceListData];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    listTab.delegate = self;
    listTab.dataSource = self;
    listTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTab];
    
}
#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listMultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //时间
    UILabel* dateLab = [[UILabel alloc] init];
    dateLab.layer.cornerRadius = 6.0f;
    dateLab.layer.borderWidth = 1.0f;
    dateLab.layer.borderColor = BaseColor.CGColor;
    dateLab.textColor = BaseColor;
    dateLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.centerY.equalTo(cell.mas_centerY);
        make.height.equalTo(cell.mas_height).multipliedBy(0.8);
        make.width.equalTo(cell.mas_width).multipliedBy(0.8);
    }];
    //往按钮里面添加数据
    if ([self.listMultArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = self.listMultArr[indexPath.row];
        dateLab.text = [NSString stringWithFormat:@"%@ 医嘱",dict[@"visit_date"]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击查看医嘱");
    if ([self.listMultArr[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = self.listMultArr[indexPath.row];
        MDMyAdviceDetailVC* adviceDetailVC = [[MDMyAdviceDetailVC alloc] init];
        adviceDetailVC.adviceIdStr = dict[@"id"];
        [self.navigationController pushViewController:adviceDetailVC animated:YES];
    }
}

#pragma mark -- 获取我的医嘱
- (void)getMyAdviceListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.userIdStr forKey:@"userid"];
    NSString* url = PATH(@"%@/getCaseAdviceList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray* listArr = responseObj[@"data"];
                    [self.listMultArr removeAllObjects];
                    [self.listMultArr addObjectsFromArray:listArr];
                    [listTab reloadData];
                    
                }else{
                    
                    [XHToast showCenterWithText:@"数据格式不正确"];
                }
                
                
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
}







@end
