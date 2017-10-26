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

@interface MDChooseSickerVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView* sickerTab;
}


@property (nonatomic,strong)YYSearchBar *searchBar;

@end

@implementation MDChooseSickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择患者";
    
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //加载医生的患者列表
    [self getSickerListData];
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
    sickerTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, LSSCREENWIDTH, LSSCREENHEIGHT - 60) style:UITableViewStyleGrouped];
    sickerTab.delegate = self;
    sickerTab.dataSource = self;
    [self.view addSubview:sickerTab];
    
    //注册Cell
    [sickerTab registerNib:[UINib nibWithNibName:@"MDChooseSickerCell" bundle:nil] forCellReuseIdentifier:@"mDChooseSickerCell"];
    
    
}
#pragma mark -- UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDChooseSickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDChooseSickerCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark -- 获取分组列表
- (void)getSickerListData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@"" forKey:@"age"];
    [param setValue:@"" forKey:@"labels"];
    [param setValue:@"" forKey:@"sex"];
    [param setValue:@"" forKey:@"username"];
    
    NSString* url = PATH(@"%@/queryPatientList");
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",responseObj);
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                /*
                NSArray *lists = [NSArray yy_modelArrayWithClass:[MDSickerGroupModel class] json:responseObj[@"data"]];
                
                [self.groupDataArr removeAllObjects];
                
                for (MDSickerGroupModel* groupModel in lists) {
                    for (MDSickerGroupDataModel* groupDataModel in groupModel.groupData) {
                        [self.groupDataArr addObject:groupDataModel];
                    }
                    
                }
                
                self.indexArray = [BMChineseSort IndexWithArray:self.groupDataArr Key:@"username"];
                self.letterResultArr = [BMChineseSort sortObjectArray:self.groupDataArr Key:@"username"];
                
                */
                [sickerTab reloadData];
                
                NSLog(@"1231");
                
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
