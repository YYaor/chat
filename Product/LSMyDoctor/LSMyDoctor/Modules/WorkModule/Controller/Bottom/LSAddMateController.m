//
//  LSAddMateController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSAddMateController.h"
#import "YYSearchBar.h"
#import "LSPatientListCell.h"
#import "MDPeerDetailVC.h"
#import "MDDoctorListModel.h"

@interface LSAddMateController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)YYSearchBar *searchBar;
@property (nonatomic,strong)UITableView *dataTableView;
//服务器返回数组
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LSAddMateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加同行";
    
    [self initForView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取详
    [self getDoctorListRequestDataWithCity:nil country:nil department:nil doctorName:nil hospital:nil];
}

-(void)initForView{
    [self.view addSubview:self.dataTableView];
    
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSPatientListCell"];
    if (!cell) {
        cell = [[LSPatientListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPatientListCell"];
    }
    MDDoctorListModel* listModel = self.dataArray[indexPath.row];
    cell.modelImgUrlStr = listModel.doctor_image;
    cell.modelNameStr = listModel.doctor_name;
    cell.modelValueStr = [NSString stringWithFormat:@"%@  %@  %@",listModel.doctor_title,listModel.department_name,listModel.hospital_name];
    cell.goodAt = listModel.doctor_specialty;
    
    cell.hideChoosed = YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDDoctorListModel* listModel = self.dataArray[indexPath.row];
    MDPeerDetailVC* peerDetailVC = [[MDPeerDetailVC alloc] init];
    peerDetailVC.isFriend = listModel.isFriend;
    peerDetailVC.doctorIdStr = listModel.doctor_id;
    [self.navigationController pushViewController:peerDetailVC animated:YES];
}

-(void)keyboardDown{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self keyboardDown];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.backgroundColor = [UIColor whiteColor];
        _dataTableView.tableHeaderView = self.searchBar;
    }
    return _dataTableView;
}

-(YYSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[YYSearchBar alloc]initWithSearchTab];
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 52);
        _searchBar.delegate = self;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 4;
        _searchBar.placeString = @"搜索同行";
    }
    return _searchBar;
}

#pragma mark -- 获取医生列表
- (void)getDoctorListRequestDataWithCity:(NSString*)cityStr country:(NSString*)countryStr department:(NSString*)departmentStr doctorName:(NSString*)docotorNameStr hospital:(NSString*)hopitalNameStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:cityStr forKey:@"city"];
    [param setValue:countryStr forKey:@"county"];
    [param setValue:departmentStr forKey:@"department"];
    [param setValue:docotorNameStr forKey:@"doctorName"];
    [param setValue:hopitalNameStr forKey:@"hospital"];
    
    NSString* url = PATH(@"%@/doctorList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDoctorListModel class] json:responseObj[@"data"]];
                
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:list];
                
                [_dataTableView reloadData];
                
            }else
            {
                [XHToast showCenterWithText:responseObj[@"message"]];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
    } failBlock:^(NSError *error) {
//        //[XHToast showCenterWithText:@"fail"];
    }];

}





@end
