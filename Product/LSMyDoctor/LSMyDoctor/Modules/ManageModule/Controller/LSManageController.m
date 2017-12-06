//
//  LSManageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageController.h"
#import "MDSickerDetailVC.h"
#import "YYSearchBar.h"
#import "MDManageGroupCell.h"
#import "LSManageCell.h"
#import "LSManageModel.h"
#import "MDSickerGroupVC.h"
#import "MDAddGroupVC.h"
#import "MDSickerGroupModel.h"

static NSString *cellId = @"LSManageCell";

@interface LSManageController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSString* groupNumStr;
}

@property (nonatomic, strong) UITableView *sickerTab;

@property (nonatomic,strong) NSMutableArray *groupDataArr;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic,strong)YYSearchBar *searchBar;

@end

@implementation LSManageController


#pragma mark -- 懒加载
- (NSMutableArray *)groupDataArr{
    
    if (_groupDataArr == nil) {
        _groupDataArr = [NSMutableArray array];
        
    }
    return _groupDataArr;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"患者管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addGroupBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [addGroupBtn addTarget:self action:@selector(addGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addGroupBtn setTitle:@"创建群" forState:UIControlStateNormal];
    [addGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:addGroupBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //加载医生的患者列表
    [self getSickerListDataWithUserName:nil];
    //获取群组列表
    [self getSickerGroupListData];
}
#pragma mark -- 创建群按钮点击
- (void)addGroupBtnClick
{
    NSLog(@"创建群按钮点击");
    MDAddGroupVC* addGroupVC = [[MDAddGroupVC alloc] init];
    addGroupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addGroupVC animated:YES];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    
    self.searchBar = [[YYSearchBar alloc] initWithSearchTab];
    self.searchBar.frame = CGRectMake(0, 0, LSSCREENWIDTH, 52);
    self.searchBar.delegate = self;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.cornerRadius = 4;
    self.searchBar.placeholder = @"请输入患者姓名";
    
    [self.view addSubview:_searchBar];
    
    //列表
    self.sickerTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 65 - 45) style:UITableViewStyleGrouped];
    self.sickerTab.delegate = self;
    self.sickerTab.dataSource = self;
    self.sickerTab.sectionIndexBackgroundColor = [UIColor clearColor];
    self.sickerTab.sectionIndexColor = BaseColor;
    [self.view addSubview:self.sickerTab];
    
    //注册Cell
    [self.sickerTab registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    [self.sickerTab registerNib:[UINib nibWithNibName:@"MDManageGroupCell" bundle:nil] forCellReuseIdentifier:@"mDManageGroupCell"];
    
    
}

#pragma mark -- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self getSickerListDataWithUserName:searchBar.text];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self getSickerListDataWithUserName:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self getSickerListDataWithUserName:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self getSickerListDataWithUserName:searchBar.text];
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [[self.letterResultArr objectAtIndex:section -1] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.00001f;
    }else{
        return 30.0f;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return [self.indexArray objectAtIndex:section - 1];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MDManageGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDManageGroupCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.groupNumLab.text = groupNumStr;
        return cell;
        
     }else{
        LSManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSManageCell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDataWithEntity:self.letterResultArr[indexPath.section -1][indexPath.row]];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //点击群组
        NSLog(@"点击群组");
        MDSickerGroupVC* sickerGroupVC = [[MDSickerGroupVC alloc] init];
        sickerGroupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sickerGroupVC animated:YES];
    }else{
        MDSickerDetailVC* sickerDetailVC = [[MDSickerDetailVC alloc] init];
        LSManageModel* model = self.letterResultArr[indexPath.section - 1][indexPath.row];
        sickerDetailVC.sickerIdStr = model.user_id;
        sickerDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sickerDetailVC animated:YES];
    }
    
}

#pragma mark -- 获取分组列表
- (void)getSickerListDataWithUserName:(NSString*)usernameStr
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:usernameStr forKey:@"username"];
    
    NSString* url = PATH(@"%@/queryPatientList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSArray *dataList = [NSArray yy_modelArrayWithClass:[LSManageModel class] json:responseObj[@"data"]];
            
            [weakSelf.groupDataArr removeAllObjects];
            [weakSelf.groupDataArr addObjectsFromArray:dataList];
            
            if (dataList.count == 0)
            {
                [XHToast showCenterWithText:@"您还没有添加患者"];
            }
            
            weakSelf.indexArray = [BMChineseSort IndexWithArray:weakSelf.groupDataArr Key:@"username"];
            weakSelf.letterResultArr = [BMChineseSort sortObjectArray:weakSelf.groupDataArr Key:@"username"];
            
            [weakSelf.sickerTab reloadData];
            
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取会诊讨论组列表
- (void)getSickerGroupListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryGroupList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDSickerGroupModel class] json:responseObj[@"data"]];
                groupNumStr = [NSString stringWithFormat:@"%lu",(unsigned long)list.count];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [_sickerTab reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
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
