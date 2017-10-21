//
//  LSChoosePatientController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/9.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSChoosePatientController.h"
#import "YYSearchBar.h"
#import "LSPatientListCell.h"
#import "LSPatientModel.h"

@interface LSChoosePatientController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)YYSearchBar *searchBar;

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)NSMutableArray *sectionArray;

@property (nonatomic,strong)NSMutableDictionary *dataDic;
//搜索数组
@property (nonatomic,strong)NSMutableArray *searchArray;
//服务器返回数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//整理后的数组
@property (nonatomic,strong)NSMutableArray *orderArray;
//选择的对象
@property (nonatomic,strong)NSMutableArray *chooseArray;
@end

@implementation LSChoosePatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择患者";
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
    [self initForView];
    [self loadData];
}

-(void)keyboardDown{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
    
    [self.dataArray addObjectsFromArray: [NSArray arrayWithObjects:model1,model2,model3,model4, nil]];
    
    [LSUtil getOrderPatientList:self.dataArray patientListDictBlock:^(NSDictionary<NSString *,NSMutableDictionary *> *addressBookDict, NSArray *nameKeys) {
        //得到排序后的数组
        [self.sectionArray addObjectsFromArray:nameKeys];
        self.dataDic = [[NSMutableDictionary alloc]initWithDictionary:addressBookDict];
        
        for (int i = 0; i < nameKeys.count; i++) {
          NSArray *nameArray = [self.dataDic objectForKey:nameKeys[i]];
            NSMutableArray *rowArray = [[NSMutableArray alloc]init]; // 每个字母里面包含的数组
            NSArray *selectArray = [NSArray array];
            for (int j = 0; j < nameArray.count ; j++) {
                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name == %@", [nameArray[j] objectForKey:@"name"]];
                selectArray = [self.dataArray filteredArrayUsingPredicate:filterPredicate];
                [rowArray addObjectsFromArray:selectArray];
            }
            [self.orderArray addObject:rowArray];

        }
        [self.dataTableView reloadData];
    }];
}

-(void)sureClick{
    for (LSPatientModel *model in self.dataArray) {
        if (model.isChoosed) {
            [self.chooseArray addObject:model];
        }
    }
    if (self.chooseBlock) {
        self.chooseBlock(self.chooseArray);
    }

    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.searchBar.text.length > 0) {
        return 1;
    }else{
        return self.sectionArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchBar.text.length > 0) {
        return self.searchArray.count;
    }else{
        return [self.orderArray[section] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSPatientListCell"];
    if (!cell) {
        cell = [[LSPatientListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPatientListCell"];
    }
    if (self.searchBar.text.length > 0) {
        cell.model = self.searchArray[indexPath.row];
    }else{
        NSArray *dataArray = self.orderArray[indexPath.section];
        cell.model = dataArray[indexPath.row];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.searchBar.text.length > 0) {
        return [[UIView alloc]init];
    }else{
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UILabel *sectionLabel = [[UILabel alloc]init];
        sectionLabel.font = [UIFont systemFontOfSize:15];
        sectionLabel.textColor = [UIColor blackColor];
        sectionLabel.text = self.sectionArray[section];
        [headView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.equalTo(headView).offset(14);
        }];
        
        return headView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchBar.text.length > 0) {
        return 0;
    }else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientModel *chooseModel = nil;
    if (self.searchBar.text.length > 0) {
        chooseModel = self.searchArray[indexPath.row];
        for (LSPatientModel *model in self.searchArray) {
            if (model != chooseModel) {
                model.isChoosed = NO;
            }
        }

    }else{
        NSArray *dataArray = self.orderArray[indexPath.section];
        chooseModel = dataArray[indexPath.row];
        for (LSPatientModel *model in self.dataArray) {
            if (model != chooseModel) {
                model.isChoosed = NO;
            }
        }
    }
    chooseModel.isChoosed = !chooseModel.isChoosed;
    [self.dataTableView reloadData];
    
}

#pragma mark - searchBarDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self keyboardDown];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        [self setFilterString:searchBar.text];
    }else{
        [self.searchArray removeAllObjects];
        [self.dataTableView reloadData];
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)setFilterString:(NSString *)filterString {
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", filterString];
    [self.searchArray addObjectsFromArray:[self.dataArray filteredArrayUsingPredicate:filterPredicate]];

    [self.dataTableView reloadData];
}


-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

-(NSMutableArray *)chooseArray{
    if (!_chooseArray) {
        _chooseArray = [[NSMutableArray alloc] init];
    }
    return _chooseArray;
}

-(NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [[NSMutableArray alloc] init];
    }
    return _orderArray;
}

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] init];
    }
    return _searchArray;
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
    }
    return _searchBar;
}


@end
