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
#import "LSPatientModel.h"
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
    [self loadData];
}

-(void)initForView{
    [self.view addSubview:self.dataTableView];
    
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

-(void)loadData{
    LSPatientModel *model1 = [[LSPatientModel alloc]init];
    model1.name = @"张三";
    model1.sex = @"男";
    model1.age = @"10";
    model1.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";
    
    LSPatientModel *model2 = [[LSPatientModel alloc]init];
    model2.name = @"李四";
    model2.sex = @"女";
    model2.age = @"10";
    
    LSPatientModel *model3 = [[LSPatientModel alloc]init];
    model3.name = @"王五";
    model3.sex = @"男";
    //    model3.age = @"15";
    
    LSPatientModel *model4 = [[LSPatientModel alloc]init];
    model4.name = @"李四四";
    model4.sex = @"女";
    model4.age = @"134";
    
    [self.dataArray addObject:model1];
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
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
