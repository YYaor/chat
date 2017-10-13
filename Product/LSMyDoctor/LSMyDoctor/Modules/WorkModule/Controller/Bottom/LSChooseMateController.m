//
//  LSAddMateController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSChooseMateController.h"
#import "YYSearchBar.h"
#import "LSPatientListCell.h"
#import "LSPatientModel.h"
@interface LSChooseMateController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UITableView *dataTableView;
//服务器返回数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//选择的对象
@property (nonatomic,strong)NSMutableArray *chooseArray;

@end

@implementation LSChooseMateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加同行";
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
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
    LSPatientModel *chooseModel = self.dataArray[indexPath.row];
    for (LSPatientModel *model in self.dataArray) {
        if (chooseModel != model) {
            model.isChoosed = NO;
        }
    }
    chooseModel.isChoosed = !chooseModel.isChoosed;
    [self.dataTableView reloadData];
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

-(NSMutableArray *)chooseArray{
    if (!_chooseArray) {
        _chooseArray = [[NSMutableArray alloc] init];
    }
    return _chooseArray;
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
    }
    return _dataTableView;
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
