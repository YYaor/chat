//
//  LSManageController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/25.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSManageController.h"

#import "LSManageDetailController.h"

#import "YYSearchBar.h"
#import "LSManageCell.h"
#import "LSManageModel.h"

static NSString *cellId = @"LSManageCell";

@interface LSManageController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

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
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"创建群" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //加载医生的患者列表
    [self getSickerListDataWithUserName:nil];
}
#pragma mark -- 确定按钮点击
- (void)sureBtnClick
{
    NSLog(@"确定按钮点击");
//    NSMutableArray* chooseArr = [NSMutableArray array];
//    [chooseArr removeAllObjects];
//    for (MDChooseSickerModel *model in self.groupDataArr) {
//        if (model.is_Selected) {
//            [chooseArr addObject:model];
//        }
//    }
//    if (self.chooseBlock) {
//        self.chooseBlock(chooseArr);
//    }
//    
//    
//    [self.navigationController popViewControllerAnimated:YES];
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
    self.sickerTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 65) style:UITableViewStyleGrouped];
    self.sickerTab.delegate = self;
    self.sickerTab.dataSource = self;
    self.sickerTab.sectionIndexBackgroundColor = [UIColor clearColor];
    self.sickerTab.sectionIndexColor = BaseColor;
    [self.view addSubview:self.sickerTab];
    
    //注册Cell
    [self.sickerTab registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}

#pragma mark -- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self getSickerListDataWithUserName:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self getSickerListDataWithUserName:searchBar.text];
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexArray objectAtIndex:section];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSManageCell"];
    [cell setDataWithEntity:self.letterResultArr[indexPath.section][indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LSManageDetailController *vc = [[LSManageDetailController alloc] initWithNibName:@"LSManageDetailController" bundle:nil];
    vc.model = self.letterResultArr[indexPath.section][indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 获取分组列表
- (void)getSickerListDataWithUserName:(NSString*)usernameStr
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryPatientList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSArray *dataList = [NSArray yy_modelArrayWithClass:[LSManageModel class] json:responseObj[@"data"]];
            
            [weakSelf.groupDataArr removeAllObjects];
            [weakSelf.groupDataArr addObjectsFromArray:dataList];
            
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

@end
