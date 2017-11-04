//
//  MDEditGroupVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDEditGroupVC.h"
#import "MDSickerGroupModel.h"
#import "MDEditSickerGroupCell.h"

@interface MDEditGroupVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* groupTab;
}
@property (nonatomic , strong) NSMutableArray* groupArr;

@end

@implementation MDEditGroupVC
#pragma mark -- 懒加载
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [[NSMutableArray alloc] init];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑分组";
    
    
    [self setUpUi];
}
- (void)viewWillAppear:(BOOL)animated
{
    //获取分组列表
    [self getGroupDataRequest];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    
    groupTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 64) style:UITableViewStyleGrouped];
    groupTab.delegate = self;
    groupTab.dataSource = self;
    [self.view addSubview:groupTab];
    //注册Cell
    [groupTab registerNib:[UINib nibWithNibName:@"MDEditSickerGroupCell" bundle:nil] forCellReuseIdentifier:@"mDEditSickerGroupCell"];
    
    //保存按钮
    UIButton* saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 60, LSSCREENWIDTH - 60, 40)];
    [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:BaseColor];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6.0f;
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];

}
#pragma mark -- 保存按钮点击
- (void)saveBtnClick
{
    NSLog(@"保存按钮点击");
    
    NSMutableArray* userIdMultArr = [NSMutableArray array];
    [userIdMultArr removeAllObjects];
    for (MDSickerGroupModel* model in self.groupArr) {
        if (model.isSelected) {
            [userIdMultArr addObject:model.groupId];
        }
    }
    NSString* userIdStr = [userIdMultArr componentsJoinedByString:@","];
    [self changeGroupDataWithGroupIdStr:userIdStr];
    
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDEditSickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDEditSickerGroupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MDSickerGroupModel* sickerGroupModel = self.groupArr[indexPath.section];
    cell.boxBtn.selected = sickerGroupModel.isSelected;
    [cell.groupImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_HOST,sickerGroupModel.img_url]] placeholderImage:[UIImage imageNamed:@"people_blue"]];
    cell.groupNameLab.text = sickerGroupModel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MDSickerGroupModel* sickerGroupModel = self.groupArr[indexPath.section];
    sickerGroupModel.isSelected = !sickerGroupModel.isSelected;
    [groupTab reloadData];
}

#pragma mark -- 获取分组列表
- (void)getGroupDataRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/queryGroupList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                NSArray* list = [NSArray yy_modelArrayWithClass:[MDSickerGroupModel class] json:responseObj[@"data"]];
                [self.groupArr removeAllObjects];
                [self.groupArr addObjectsFromArray:list];
                NSArray* haveGroupArr = [self.groupIdStr componentsSeparatedByString:@","];
                for (NSString* group in haveGroupArr) {
                    for (MDSickerGroupModel* model in self.groupArr) {
                        if ([model.groupId isEqualToString:group]) {
                            model.isSelected = YES;
                        }
                    }
                }
                
                
                [groupTab reloadData];
                
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
#pragma mark -- 修改分组列表
- (void)changeGroupDataWithGroupIdStr:(NSString*)groupIdStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:groupIdStr forKey:@"groupids"];
    [param setValue:self.userIdStr forKey:@"userid"];
    
    NSString* url = PATH(@"%@/updatePatientGroups");
    
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
        //[XHToast showCenterWithText:@"fail"];
    }];
}





@end
