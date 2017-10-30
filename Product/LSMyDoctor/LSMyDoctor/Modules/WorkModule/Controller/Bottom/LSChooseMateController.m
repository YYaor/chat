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
#import "MDDoctorListModel.h"

@interface LSChooseMateController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UITableView *dataTableView;
//服务器返回数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//选择的对象
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
//选择好后的结果
@property(nonatomic,strong)NSMutableArray *chooseArray;


@end

@implementation LSChooseMateController
#pragma mark -- 懒加载
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
- (NSMutableArray *)chooseArray{
    
    if (_chooseArray == nil) {
        _chooseArray = [NSMutableArray array];
        
    }
    return _chooseArray;
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
    self.navigationItem.title = @"选择同行";
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
    [self initForView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getMyPeerListData];
}

-(void)initForView{
    [self.view addSubview:self.dataTableView];
    
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
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
    
    NSMutableArray* haveIdArr = [NSMutableArray array];
    [haveIdArr removeAllObjects];
    
    for (MDGroupUserModel* userModel in self.groupDetailModel.users) {
        [haveIdArr addObject:userModel.doctor_id];
    }
    if ([haveIdArr containsObject:listModel.doctor_id]) {
        cell.isChoosed = YES;
    }else{
        cell.isChoosed = listModel.isChoise;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *listArray = self.letterResultArr[indexPath.section];
    
    MDDoctorListModel* listModel = listArray[indexPath.row];
    
    NSMutableArray* doctorIdArr = [NSMutableArray array];
    [doctorIdArr removeAllObjects];
    for (MDGroupUserModel* userModel in self.groupDetailModel.users) {
        [doctorIdArr addObject:userModel.doctor_id];
    }
    
    BOOL isHere = [doctorIdArr containsObject:listModel.doctor_id];
    if (!isHere) {
        listModel.isChoise = !listModel.isChoise;
    }
    
    [self.dataTableView reloadData];
}

#pragma mark -- 右上确定按钮点击
-(void)sureClick{
    
    for (MDDoctorListModel *model in self.dataArray) {
        if (model.isChoise) {
            [self.chooseArray addObject:model];
        }
    }
    
    if (self.submitData) {
        //需要提交数据 -- 修改群成员
        NSMutableArray* submitArr = [NSMutableArray array];
        [submitArr removeAllObjects];
        NSMutableArray* haveIdArr = [NSMutableArray array];
        [haveIdArr removeAllObjects];
        
        for (MDGroupUserModel* userModel in self.groupDetailModel.users) {
            [haveIdArr addObject:userModel.doctor_id];
        }
        
        for (MDDoctorListModel *model in self.chooseArray) {
            if (![haveIdArr containsObject:model.doctor_id]) {
                [submitArr addObject:model.doctor_id];
            }
        }
        
        
        
        NSString* addStr = [submitArr componentsJoinedByString:@","];
        
        [self changeMemberDataWithUserId:addStr];
        
        
        
    }else{
        //需要返回数据，创建讨论组时
        if (self.chooseBlock) {
            
            self.chooseBlock(self.chooseArray);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
                
                if (self.submitData && self.groupDetailModel.users.count > 0) {
                    //修改群组成员，将已有的群组成员标记已选中
                    for (MDGroupUserModel* userModel in self.groupDetailModel.users) {
                        for (MDDoctorListModel* listModel in self.dataArray) {
                            if ([userModel.doctor_id isEqualToString:listModel.doctor_id]) {
                                listModel.isChoise = YES;
                            }
                        }
                    }
                }
                
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

#pragma mark -- 提交修改成员的数据
- (void)changeMemberDataWithUserId:(NSString*)userIdStr;
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:userIdStr forKey:@"doctorids"];
    [param setValue:self.groupIdStr forKey:@"roomid"];
    
    NSString* url = PATH(@"%@/addRoomUser");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                [self.navigationController popViewControllerAnimated:YES];
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
