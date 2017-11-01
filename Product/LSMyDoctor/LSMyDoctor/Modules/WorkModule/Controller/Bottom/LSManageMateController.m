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
#import "LSPatientListCell.h"
#import "MDPeerDetailVC.h"
#import "MDConsulteDisccussVC.h"
#import "MDDoctorListModel.h"
#import "MDDiscussListModel.h"

@interface LSManageMateController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)NSMutableArray *dataArray; //请求回来总的数据

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

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

- (NSMutableArray *)indexArray{
    
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
        
    }
    return _indexArray;
}
- (NSMutableArray *)letterResultArr{
    
    if (_letterResultArr == nil) {
        _letterResultArr = [NSMutableArray array];
        
    }
    return _letterResultArr;
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
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_white_public"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
    [self initForView];
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取我的同行列表
    [self getMyPeerListData];
    //获取讨论组列表
    [self getDiscussListData];
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
    LSBeginChatController *beginChatVC = [[LSBeginChatController alloc] init];
    [self.navigationController pushViewController:beginChatVC animated:YES];
}
#pragma mark -- 添加同行按钮点击
-(void)addButtonClick{
    //添加同行
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
    [self.moreView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewClick)]];
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

#pragma mark -- 点击moreView空白处
- (void)moreViewClick
{
    self.moreView.hidden = YES;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexArray objectAtIndex:section];
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.letterResultArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSPatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSPatientListCell"];
    if (!cell) {
        cell = [[LSPatientListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSPatientListCell"];
    }
    NSArray *dataArray = self.letterResultArr[indexPath.section];
    
    MDDoctorListModel* listModel = dataArray[indexPath.row];
    cell.modelImgUrlStr = listModel.doctor_image;
    cell.modelNameStr = listModel.doctor_name;
    cell.modelValueStr = [NSString stringWithFormat:@"%@  %@  %@",listModel.doctor_title,listModel.department_name,listModel.hospital_name];
    cell.goodAt = listModel.doctor_specialty;
    
    cell.hideChoosed = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击某一行，查看医生详情资料");
    NSArray *dataArray = self.letterResultArr[indexPath.section];
    MDDoctorListModel* listModel = dataArray[indexPath.row];
    MDPeerDetailVC* peerDetailVC = [[MDPeerDetailVC alloc] init];
    peerDetailVC.isFriend = YES;
    peerDetailVC.doctorIdStr = listModel.doctor_id;
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
    moreImage.image = [UIImage imageNamed:@"right_white_Public"];
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
        make.right.equalTo(moreImage.mas_left).offset(-10);
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
    MDConsulteDisccussVC* consulteDisccussVC = [[MDConsulteDisccussVC alloc] init];
    
    [self.navigationController pushViewController:consulteDisccussVC animated:YES];
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

#pragma mark -- 获取我的同行列表
- (void)getMyPeerListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryPeersList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDoctorListModel class] json:responseObj[@"data"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:list];
                
                self.indexArray = [BMChineseSort IndexWithArray:self.dataArray Key:@"doctor_name"];
                self.letterResultArr = [BMChineseSort sortObjectArray:self.dataArray Key:@"doctor_name"];
                
                
                [_dataTableView reloadData];
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark -- 获取会诊讨论组列表
- (void)getDiscussListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryRoomList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDDiscussListModel class] json:responseObj[@"data"]];
                self.groupNumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)list.count];
                
            }else
            {
                [XHToast showCenterWithText:@"获取数据失败"];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}






@end
