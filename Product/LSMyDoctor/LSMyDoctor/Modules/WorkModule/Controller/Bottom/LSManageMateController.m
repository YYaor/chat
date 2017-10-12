//
//  LSManageMateController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageMateController.h"
#import "LSAddMateController.h"
#import "LSBeginChatController.h"

#import "LSPatientModel.h"
#import "LSPatientListCell.h"


@interface LSManageMateController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableArray *sectionArray;

@property (nonatomic,strong)NSMutableArray *orderArray;

@property (nonatomic,strong)NSMutableDictionary *dataDic;

@property (nonatomic,strong)UILabel *groupNumLabel;

@property (nonatomic,strong)UIView *moreView;

@end

@implementation LSManageMateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"同行管理";
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = moreItem;
    
    [self initForView];
    [self loadData];
}

-(void)moreClick{
    self.moreView.hidden = !self.moreView.hidden;
}

-(void)chatButtonClick{
    //发起讨论
    LSBeginChatController *vc = [[LSBeginChatController alloc]initWithNibName:@"LSBeginChatController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addButtonClick{
    //添加同行
    LSAddMateController *vc = [[LSAddMateController alloc]initWithNibName:@"LSAddMateController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initForView{
    
    UIView *groupView = [self getMoreGroupView];
    [self.view addSubview:groupView];
    [groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(45);
    }];
    
    self.moreView = [[UIView alloc]init];
    self.moreView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    self.moreView.userInteractionEnabled = YES;
    
    [self.moreView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewClick)] ];
    
    [self.moreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    UIView *buttonView= [self getMoreView];
    [self.moreView addSubview:buttonView];
    [buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreView).offset(1);
        make.right.equalTo(self.moreView).offset(-14);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

-(void)moreViewClick{
    self.moreView.hidden = YES;
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
    model2.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";

    
    LSPatientModel *model3 = [[LSPatientModel alloc]init];
    model3.name = @"王五";
    model3.sex = @"男";
    model3.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";

    //    model3.age = @"15";
    
    LSPatientModel *model4 = [[LSPatientModel alloc]init];
    model4.name = @"李四四";
    model4.sex = @"女";
    model4.age = @"134";
    model4.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";

    
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

#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSPatientListCell"];
    if (!cell) {
        cell = [[LSPatientListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPatientListCell"];
    }
    NSArray *dataArray = self.orderArray[indexPath.section];
    cell.model = dataArray[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

-(NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [[NSMutableArray alloc] init];
    }
    return _orderArray;
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

-(UIView *)getMoreGroupView{
    UIView *moreGroupView = [[UIView alloc]init];
    
    UIImageView *groupImageView = [[UIImageView alloc]init];
    groupImageView.image = [UIImage imageNamed:@"people_blue"];
    [moreGroupView addSubview:groupImageView];
    
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreGroupView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(moreGroupView).offset(14);
    }];
    
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"会诊讨论组";
    title.textColor = [UIColor colorFromHexString:@"333333"];
    [moreGroupView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreGroupView);
        make.left.equalTo(groupImageView.mas_right).offset(5);
    }];
    
    UIImageView *moreImage = [[UIImageView alloc]init];
    moreImage.image = [UIImage imageNamed:@"back_g"];
    [moreGroupView addSubview:moreImage];
    [moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 19));
        make.centerY.equalTo(moreGroupView);
        make.right.equalTo(moreGroupView).offset(-14);
    }];
    
    self.groupNumLabel = [UILabel new];
    self.groupNumLabel.font = [UIFont systemFontOfSize:14];
    self.groupNumLabel.text = @"8";
    self.groupNumLabel.textColor = [UIColor colorFromHexString:@"8b8b8b"];
    [moreGroupView addSubview:self.groupNumLabel];
    
    [self.groupNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreGroupView);
        make.right.equalTo(moreImage.mas_left).offset(-5);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    [moreGroupView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupImageView.mas_left);
        make.bottom.right.equalTo(moreGroupView);
        make.height.mas_equalTo(1);
    }];
    
    return moreGroupView;
}

-(UIView *)getMoreView{
    UIView *moreView = [UIView new];
    
    UIButton *chatButton = [[UIButton alloc]init];
    [chatButton setTitle:@"发起讨论" forState:UIControlStateNormal];
    [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chatButton setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    chatButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [chatButton addTarget:self action:@selector(chatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:chatButton];
    
    [chatButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(moreView);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *addButton = [[UIButton alloc]init];
    [addButton setTitle:@"添加同行" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundColor:[UIColor colorFromHexString:LSGREENCOLOR]];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:addButton];
    
    [addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(moreView);
        make.height.mas_equalTo(50);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor whiteColor];
    [moreView addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreView);
        make.left.right.equalTo(moreView);
        make.height.mas_equalTo(1);
    }];
    
    return moreView;
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
