//
//  MDChooseSickerVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDChooseSickerVC.h"
#import "YYSearchBar.h"
#import "MDChooseSickerCell.h"
#import "MDChooseSickerModel.h"

@interface MDChooseSickerVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView* sickerTab;
}

@property (nonatomic,strong) NSMutableArray *groupDataArr;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic,strong)YYSearchBar *searchBar;

@end

@implementation MDChooseSickerVC

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
    
    self.title = @"选择患者";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    NSMutableArray* chooseArr = [NSMutableArray array];
    [chooseArr removeAllObjects];
    for (MDChooseSickerModel *model in self.groupDataArr) {
        if (model.is_Selected) {
            [chooseArr addObject:model];
        }
    }
    if (self.chooseBlock) {
        self.chooseBlock(chooseArr);
    }

    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    //创建界面
    
    _searchBar = [[YYSearchBar alloc] initWithSearchTab];
    _searchBar.frame = CGRectMake(0, 0, LSSCREENWIDTH, 52);
    _searchBar.delegate = self;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 4;
    _searchBar.placeholder = @"请输入患者姓名";
    
    [self.view addSubview:_searchBar];
    
    //列表
    sickerTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 65) style:UITableViewStyleGrouped];
    sickerTab.delegate = self;
    sickerTab.dataSource = self;
    sickerTab.sectionIndexBackgroundColor = [UIColor clearColor];
    sickerTab.sectionIndexColor = BaseColor;
    [self.view addSubview:sickerTab];
    
    //注册Cell
    [sickerTab registerNib:[UINib nibWithNibName:@"MDChooseSickerCell" bundle:nil] forCellReuseIdentifier:@"mDChooseSickerCell"];
    
    
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
    return 80.0f;
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
    MDChooseSickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDChooseSickerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MDChooseSickerModel* sickerModel = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.isSelected = sickerModel.is_Selected;
    cell.userNameStr = sickerModel.username;
    cell.sexAndAgeStr = [NSString stringWithFormat:@"%@   %@",sickerModel.sex,[NSString getAgeFromBirthday:sickerModel.birthday]];
 
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDChooseSickerModel* sickerModel = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    for (MDChooseSickerModel* chooseModel in self.groupDataArr) {
        chooseModel.is_Selected = NO;
    }
    sickerModel.is_Selected = !sickerModel.is_Selected;
    
    [sickerTab reloadData];
}

#pragma mark -- 获取分组列表
- (void)getSickerListDataWithUserName:(NSString*)usernameStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    if (usernameStr.length > 0 || usernameStr != nil) {
        [param setValue:usernameStr forKey:@"username"];
    }
    NSString* url = PATH(@"%@/queryPatientList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",responseObj);
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                NSArray *lists = [NSArray yy_modelArrayWithClass:[MDChooseSickerModel class] json:responseObj[@"data"]];
                
                [self.groupDataArr removeAllObjects];
                [self.groupDataArr addObjectsFromArray:lists];
                
                self.indexArray = [BMChineseSort IndexWithArray:self.groupDataArr Key:@"username"];
                self.letterResultArr = [BMChineseSort sortObjectArray:self.groupDataArr Key:@"username"];
                
                [sickerTab reloadData];
                
            }else
            {
                [XHToast showCenterWithText:responseObj[@"message"]];
            }
            
        }else{
            [XHToast showCenterWithText:@"数据格式错误"];
        }
        
        
        
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
    
    
}




@end
