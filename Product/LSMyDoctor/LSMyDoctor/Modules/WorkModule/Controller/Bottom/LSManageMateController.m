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
#import "MDPeerDetailVC.h"

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
        _dataTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _dataTableView.sectionIndexColor = BaseColor;
    }
    return _dataTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"同行管理";
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    [self initForView];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.moreView.hidden = YES;
}
#pragma mark -- 右上角更多按钮点击
- (void)rightBtnClick
{
    self.moreView.hidden = !self.moreView.hidden;
}

#pragma mark -- 发起讨论按钮点击
-(void)chatButtonClick{
    //发起讨论
    self.moreView.hidden = YES;
    LSBeginChatController *beginChatVC = [[LSBeginChatController alloc] init];
    [self.navigationController pushViewController:beginChatVC animated:YES];
}
#pragma mark -- 添加同行按钮点击
-(void)addButtonClick{
    //添加同行
    self.moreView.hidden = YES;
    LSAddMateController *addMateVC = [[LSAddMateController alloc] init];
    [self.navigationController pushViewController:addMateVC animated:YES];
}

-(void)initForView{
    //会诊讨论组
    UIView *groupView = [self getMoreGroupView];
    [self.view addSubview:groupView];
    [groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    //列表
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(45);
    }];
    
    //更多按钮
    self.moreView = [[UIView alloc]init];
    self.moreView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.moreView];
    self.moreView.hidden = YES;
    self.moreView.userInteractionEnabled = YES;
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

#pragma mark - UITableViewDelegate / UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSPatientListCell"];
    if (!cell) {
        cell = [[LSPatientListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPatientListCell"];
    }
    NSArray *dataArray = self.orderArray[indexPath.section];
    cell.model = dataArray[indexPath.row];
    cell.hideChoosed = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击某一行，查看医生详情资料");
    MDPeerDetailVC* peerDetailVC = [[MDPeerDetailVC alloc] init];
    
    [self.navigationController pushViewController:peerDetailVC animated:YES];
}


#pragma mark -- 会诊讨论组定义
-(UIView *)getMoreGroupView{
    UIView *moreGroupView = [[UIView alloc]init];
    moreGroupView.backgroundColor = [UIColor whiteColor];
    
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
    title.textColor = Style_Color_Content_Black;
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
    
    [moreGroupView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreGroupViewClick)] ];
    
    return moreGroupView;
}

#pragma mark -- 会诊讨论组按钮点击
- (void)moreGroupViewClick
{
    NSLog(@"会诊讨论组按钮点击");
}
#pragma mark -- 右上角更多按钮展现View
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
