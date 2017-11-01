//
//  MDAddGroupVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDAddGroupVC.h"
#import "MDChooseSickerCell.h"
#import "MDChooseSickerModel.h"
#import "MDSickerLabelsModel.h"
#import "MDGroupCommunicateVC.h"

@interface MDAddGroupVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZHPickViewDelegate>
{
    UITextField* inputTF;//输入群组名称
}
@property (weak, nonatomic) IBOutlet UIView *selectView;//选择模块儿的View
@property (weak, nonatomic) IBOutlet UIButton *ageAreaBtn;//选择年龄区间
@property (weak, nonatomic) IBOutlet UIButton *choiseSexBtn;//选择性别
@property (weak, nonatomic) IBOutlet UIButton *choiseClassInfoBtn;//选择分类信息
@property (weak, nonatomic) IBOutlet UILabel *selectSexLab;//性别
@property (weak, nonatomic) IBOutlet UILabel *selectAgeLab;//选择年龄段
@property (weak, nonatomic) IBOutlet UILabel *selectClassLab;//选择分类信息

@property (nonatomic , strong)UITableView*      listTab;
@property (nonatomic , strong)NSMutableArray*   groupDataArr;
@property (nonatomic , strong)NSMutableArray*   indexArray;//排序后的出现过的拼音首字母数组
@property (nonatomic , strong)NSMutableArray*   letterResultArr;//排序好的结果数组
@property (nonatomic , strong)NSMutableArray*   labelsMultArr;//分类信息数组
@property (nonatomic , strong)UIView*           getView;//点击领取弹出背景层
@property (nonatomic , strong)ZHPickView*       pickview;//选择器
@property (nonatomic , strong)NSString*         selectSexStr;//选择的性别
@property (nonatomic , strong)NSString*         selectAgeStr;//选择的年龄
@property (nonatomic , strong)NSString*         selectLabelsStr;//选择的类别
@property (nonatomic , strong)NSMutableArray*   selectresultArr;//选择完成后的数组

@end

@implementation MDAddGroupVC
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
- (NSMutableArray *)labelsMultArr{
    
    if (_labelsMultArr == nil) {
        _labelsMultArr = [NSMutableArray array];
        
    }
    return _labelsMultArr;
}
- (NSMutableArray *)selectresultArr{
    
    if (_selectresultArr == nil) {
        _selectresultArr = [NSMutableArray array];
        
    }
    return _selectresultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择群成员";
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(LSSCREENWIDTH - 100, 7, 80, 30);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    self.selectSexStr = self.selectAgeStr = self.selectLabelsStr = nil;
    
    //获取分类标签
    [self getLabelsData];
    
    [self setUpUi];
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取患者列表
    [self getSickerListDataWithSex:nil ageArea:nil labels:nil];
}

#pragma mark -- 确定按钮点击
- (void)sureBtnClick
{
    NSLog(@"确定按钮点击");
    
    [self.selectresultArr removeAllObjects];
    
    if (self.submitData) {
        //已经有群，添加后直接提交
       
        NSMutableArray* haveIdArr = [NSMutableArray array];
        [haveIdArr removeAllObjects];
        
        for (MDSickerGroupUserModel* userModel in self.groupDetailModel.users) {
            [haveIdArr addObject:userModel.user_id];
        }
        
        for (MDChooseSickerModel *model in self.groupDataArr) {
            if (![haveIdArr containsObject:model.user_id]) {
                [self.selectresultArr addObject:model.user_id];
            }
        }
        
        if (self.selectresultArr.count <= 0) {
            [XHToast showCenterWithText:@"请选择新加的群成员"];
            return;
        }
        //添加群
        [self addUserToGroupRequest];
        
    }else{
        for (MDChooseSickerModel* sickerModel in self.groupDataArr) {
            if (sickerModel.is_Selected) {
                [self.selectresultArr addObject:sickerModel.user_id];
            }
        }
        
        if (self.selectresultArr.count <= 0) {
            [XHToast showCenterWithText:@"请选择群成员"];
            return;
        }
        //新建群
        _getView = [[UIView alloc] init];
        _getView.frame = [UIScreen mainScreen].bounds;
        _getView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //给视图添加点击方法
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick)];
        recognizer.numberOfTapsRequired=1;
        [_getView addGestureRecognizer:recognizer];
        
        //白色布景
        UIView* whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.userInteractionEnabled = YES;
        whiteView.layer.cornerRadius = 6.0f;
        [_getView addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_getView.mas_centerX);
            make.centerY.equalTo(_getView.mas_centerY);
            make.width.equalTo(_getView.mas_width).multipliedBy(0.8);
            make.height.equalTo(@150);
        }];
        //取消按钮
        UIButton* cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderWidth = 0.5f;
        cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left);
            make.bottom.equalTo(whiteView.mas_bottom);
            make.height.equalTo(@40);
            make.width.equalTo(whiteView.mas_width).multipliedBy(0.5);
        }];
        //确定按钮
        
        UIButton* submitBtn = [[UIButton alloc] init];
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [submitBtn setTitleColor:BaseColor forState:UIControlStateNormal];
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.borderWidth = 0.5f;
        submitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(whiteView.mas_right);
            make.bottom.equalTo(cancelBtn.mas_bottom);
            make.height.equalTo(cancelBtn.mas_height);
            make.left.equalTo(cancelBtn.mas_right);
        }];
        //请输入您的卡券
        UILabel* inputLab = [[UILabel alloc] init];
        inputLab.text = @"群组名：";
        inputLab.textColor = Style_Color_Content_Black;
        [whiteView addSubview:inputLab];
        [inputLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(10);
            make.top.equalTo(whiteView.mas_top).offset(20);
        }];
        
        inputTF = [[UITextField alloc] init];
        inputTF.layer.masksToBounds = YES;
        inputTF.delegate = self;
        [inputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        inputTF.layer.borderWidth = 1.0f;
        inputTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        inputTF.layer.cornerRadius = 4.5f;
        [whiteView addSubview:inputTF];
        [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(inputLab.mas_bottom).offset(10);
            make.centerX.equalTo(whiteView.mas_centerX);
            make.left.equalTo(whiteView.mas_left).offset(20);
            make.height.equalTo(@40);
        }];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:_getView];
    }
    
}

#pragma mark -- 阴影取消按钮点击
- (void)cancelBtnClick
{
    NSLog(@"取消");
    [inputTF resignFirstResponder];
    [_getView removeFromSuperview];
}
#pragma mark -- 确定按钮点击
- (void)submitBtnClick
{
    NSLog(@"确定按钮点击");
    [inputTF resignFirstResponder];
    if (inputTF.text.length < 1) {
        [XHToast showCenterWithText:@"请输入群组名"];
        return;
    }
    //创建群组
    [self addGroupRequestWithGroupName:inputTF.text];
    
}

#pragma mark -- 创建View
- (void)setUpUi
{
    //创建View
    self.listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, LSSCREENWIDTH, LSSCREENHEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    self.listTab.delegate = self;
    self.listTab.dataSource = self;
    self.listTab.sectionIndexBackgroundColor = [UIColor clearColor];
    self.listTab.sectionIndexColor = BaseColor;
    [self.view addSubview:self.listTab];
    //注册Cell
    [self.listTab registerNib:[UINib nibWithNibName:@"MDChooseSickerCell" bundle:nil] forCellReuseIdentifier:@"mDChooseSickerCell"];
}
#pragma mark -- 选择年龄段区间
- (IBAction)ageAreaBtnClick:(UIButton *)sender
{
    NSLog(@"选择年龄段区间");
    NSArray* ageArr = [NSArray arrayWithObjects:@"10~20",@"21~30",@"31~40",@"41~50",@"51~60",@"61~70",@"71~80", nil];
    _pickview=[[ZHPickView alloc] initPickviewWithArray:@[ageArr] isHaveNavControler:NO];
    _pickview.tag = 1;
    _pickview.delegate=self;
    [_pickview show];
}
#pragma mark -- 选择性别按钮点击
- (IBAction)choiseSexBtnClick:(UIButton *)sender
{
    NSLog(@"选择性别按钮点击");
    NSArray* sexArr = [NSArray arrayWithObjects:@"男",@"女", nil];
    _pickview=[[ZHPickView alloc] initPickviewWithArray:@[sexArr] isHaveNavControler:NO];
    _pickview.tag = 0;
    _pickview.delegate=self;
    [_pickview show];
}
#pragma mark -- 选择分类信息按钮点击
- (IBAction)choiseClassInfoBtnClick:(UIButton *)sender
{
    NSLog(@"选择分类信息按钮点击");
    NSArray * labelArr = [self.labelsMultArr copy];
    _pickview=[[ZHPickView alloc] initPickviewWithArray:@[labelArr] isHaveNavControler:NO];
    _pickview.tag = 2;
    _pickview.delegate=self;
    [_pickview show];
}
#pragma mark ZhpickVIewDelegate 点击确定方法的回调
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 0) {
        //选择性别
        self.selectSexLab.text = resultString;
        self.selectSexStr = [resultString isEqualToString:@"男"] ? @"1" : @"2";
        
    }else if (pickView.tag == 1){
        //选择年龄
        self.selectAgeLab.text = self.selectAgeStr = resultString;
    }else{
        //选择分类
        self.selectClassLab.text = self.selectLabelsStr = resultString;
    }
    
    [self getSickerListDataWithSex:self.selectSexStr ageArea:self.selectAgeStr labels:self.selectLabelsStr];
    
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
    
    sickerModel.is_Selected = !sickerModel.is_Selected;
    
    [self.listTab reloadData];
}

#pragma mark -- 获取分组列表
- (void)getSickerListDataWithSex:(NSString*)sexStr ageArea:(NSString*)ageAreaStr labels:(NSString*)labels
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    if (sexStr.length > 0) {
        [param setValue:sexStr forKey:@"sex"];
    }
    if (ageAreaStr.length > 0) {
        [param setValue:ageAreaStr forKey:@"age"];
    }
    if (labels.length > 0) {
        [param setValue:labels forKey:@"labels"];
    }
    
    NSString* url = PATH(@"%@/queryPatientList");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            NSArray *dataList = [NSArray yy_modelArrayWithClass:[MDChooseSickerModel class] json:responseObj[@"data"]];
            
            
            [weakSelf.groupDataArr removeAllObjects];
            [weakSelf.groupDataArr addObjectsFromArray:dataList];
            
            if (self.submitData && self.groupDetailModel.users.count > 0) {
                //修改群组成员，将已有的群组成员标记已选中
                for (MDSickerGroupUserModel* userModel in weakSelf.groupDetailModel.users) {
                    for (MDChooseSickerModel* listModel in weakSelf.groupDataArr) {
                        if ([userModel.user_id isEqualToString:listModel.user_id]) {
                            listModel.is_Selected = YES;
                        }
                    }
                }
            }
            
            
            weakSelf.indexArray = [BMChineseSort IndexWithArray:weakSelf.groupDataArr Key:@"username"];
            weakSelf.letterResultArr = [BMChineseSort sortObjectArray:weakSelf.groupDataArr Key:@"username"];
            
            [weakSelf.listTab reloadData];
            
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取分类信息
- (void)getLabelsData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    NSString* url = PATH(@"%@/labels");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        [self cancelBtnClick];
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.labelsMultArr removeAllObjects];
            NSArray *labelsList = [NSArray yy_modelArrayWithClass:[MDSickerLabelsModel class] json:responseObj[@"data"]];
            
            for (MDSickerLabelsModel* model in labelsList) {
                [self.labelsMultArr addObject:model.label_text];
            }
            NSLog(@"12313");
        }else
        {
            [XHToast showCenterWithText:@"数据解析错误"];
        }
    } failBlock:^(NSError *error) {
        [self cancelBtnClick];
        [XHToast showCenterWithText:@"fail"];
    }];
    
}

#pragma mark -- 创建群请求
- (void)addGroupRequestWithGroupName:(NSString*)groupNameStr
{
    NSString* userIdsStr = [self.selectresultArr componentsJoinedByString:@","];
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:groupNameStr forKey:@"name"];
    [param setValue:userIdsStr forKey:@"userids"];
    
    NSString* url = PATH(@"%@/createGroup");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        [self cancelBtnClick];
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if (responseObj[@"data"] && responseObj[@"data"][@"im_groupid"]) {
                //创建成功
                
                NSString* imGroupId = responseObj[@"data"][@"im_groupid"];
                NSLog(@"创建成功%@",imGroupId);
                MDGroupCommunicateVC* groupCommunicateVC = [[MDGroupCommunicateVC alloc] initWithConversationChatter:imGroupId conversationType:EMConversationTypeGroupChat];
                groupCommunicateVC.isPeer = NO;
                groupCommunicateVC.title = groupNameStr;
   //             groupCommunicateVC.groupIdStr = listModel.groupId;
                [self.navigationController pushViewController:groupCommunicateVC animated:YES];
                
                
                
            }else{
                [XHToast showCenterWithText:@"创建失败"];
            }
            
        }else
        {
            [XHToast showCenterWithText:@"数据解析错误"];
        }
    } failBlock:^(NSError *error) {
        [self cancelBtnClick];
        [XHToast showCenterWithText:@"fail"];
    }];
}
#pragma mark -- 加患者入群 --- 已经存在群的
- (void)addUserToGroupRequest
{
    NSString* userIdsStr = [self.selectresultArr componentsJoinedByString:@","];
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.groupIdStr forKey:@"groupid"];
    [param setValue:userIdsStr forKey:@"userids"];
    
    NSString* url = PATH(@"%@/addGroupUser");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        [self cancelBtnClick];
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            if (responseObj[@"data"] && responseObj[@"data"][@"im_groupid"]) {
                //创建成功
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [XHToast showCenterWithText:@"创建失败"];
            }
            
        }else
        {
            [XHToast showCenterWithText:@"数据解析错误"];
        }
    } failBlock:^(NSError *error) {
        [self cancelBtnClick];
        [XHToast showCenterWithText:@"fail"];
    }];
}



#pragma mark -- 限制输入字数
- (void) textFieldDidChange:(UITextField *)textField

{
    
    NSInteger kMaxLength = 20;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                
            }
            
        }
        
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLength) {
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            
        }
        
    }
    
}


@end
