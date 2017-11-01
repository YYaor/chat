//
//  MDSickerMarkVC.m
//  MyDoctor
//
//  Created by 惠生 on 17/7/12.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDSickerMarkVC.h"
#import "MDHaveMarkCell.h"
#import "MDUsefulMarkCell.h"

@interface MDSickerMarkVC ()<MDUsefulMarkCellDelegate,MDHaveMarkCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* markTab;
    UITextField* inputTF;//输入群组名称
}

@property (nonatomic,strong) UIView* getView;//点击领取弹出背景层
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation MDSickerMarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑标签";
    
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 6.5f;
    
    
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- 创建界面
- (void)setUpUI
{
    markTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 64) style:UITableViewStyleGrouped];
    markTab.delegate = self;
    markTab.dataSource = self;
    
    [self.view addSubview:markTab];
    
    //注册Cell
    [markTab registerNib:[UINib nibWithNibName:@"MDHaveMarkCell" bundle:nil] forCellReuseIdentifier:@"mDHaveMarkCell"];
    [markTab registerNib:[UINib nibWithNibName:@"MDUsefulMarkCell" bundle:nil] forCellReuseIdentifier:@"mDUsefulMarkCell"];
}

#pragma mark -- UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //已选标签
        MDHaveMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDHaveMarkCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.haveMarkArr = self.haveMarkArr;
        
        return cell;
    }else if (indexPath.section == 1){
        //常用标签
        MDUsefulMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mDUsefulMarkCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.usefulMarkArr = self.usefulMarkArr;
        
        return cell;
    }
    else{
        
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"测试";
        return cell;
    }
}
#pragma mark -- 常用标签点击
- (void)mDUsefulMarkCellMarkBtnClick:(WFHelperButton *)sender
{
    NSLog(@"点击标签内容为%@",sender.flagStr);//标签的名字
    if ([sender.flagStr isEqualToString:@"-1"]) {
        //自定义
        
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
        //请输入标签名
        UILabel* inputLab = [[UILabel alloc] init];
        inputLab.text = @"标签名：";
        inputLab.textColor = Style_Color_Content_Black;
        [whiteView addSubview:inputLab];
        [inputLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView.mas_left).offset(10);
            make.top.equalTo(whiteView.mas_top).offset(20);
        }];
        
        inputTF = [[UITextField alloc] init];
        inputTF.layer.masksToBounds = YES;
        inputTF.delegate = self;
        inputTF.layer.borderWidth = 1.0f;
        inputTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        inputTF.layer.cornerRadius = 4.5f;
        [inputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [whiteView addSubview:inputTF];
        [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(inputLab.mas_bottom).offset(10);
            make.centerX.equalTo(whiteView.mas_centerX);
            make.left.equalTo(whiteView.mas_left).offset(20);
            make.height.equalTo(@40);
        }];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:_getView];
        
        
        
        return;
    }
    
    
    if ([self.haveMarkArr containsObject: sender.flagStr]) {
        //存在
        [XHToast showCenterWithText:[NSString stringWithFormat:@"%@已存在您的已选标签中，请勿重复添加。",sender.flagStr]];
        return;
    }
    
    [self.haveMarkArr addObject:sender.flagStr];
    
    [markTab reloadData];
    
}
#pragma mark -- 已选标签按钮删除按钮点击
- (void)mDHaveMarkCellDeleteBtnClick:(WFHelperButton *)sender
{
    NSLog(@"删除%@",sender.flagStr);
    [self.haveMarkArr removeObject:sender.flagStr];
    
    [markTab reloadData];
    
}


#pragma mark -- 保存按钮点击
- (IBAction)saveBtnClick:(UIButton *)sender
{
    NSLog(@"保存按钮点击");
    
    NSString *str = [self.haveMarkArr componentsJoinedByString:@","];
    
    [self changeSickerDetailWithLabels:str];
    
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
    [self cancelBtnClick];
    if (inputTF.text.length < 1) {
        [XHToast showCenterWithText:@"请输入标签名"];
        return;
    }
    
    if ([self.haveMarkArr containsObject: inputTF.text]) {
        //存在
        [XHToast showCenterWithText:[NSString stringWithFormat:@"%@已存在您的已选标签中，请勿重复添加。",inputTF.text]];
        return;
    }
    
    [self.haveMarkArr addObject:inputTF.text];
    
    [markTab reloadData];
    
}

#pragma mark -- 修改患者资料
- (void)changeSickerDetailWithLabels:(NSString*)labelsStr
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:labelsStr forKey:@"labels"];
    [param setValue:self.userIdStr forKey:@"userid"];
    [param setValue:self.userNameStr forKey:@"username"];
    
    NSString* url = PATH(@"%@/updatePatientRemark");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [XHToast showCenterWithText:@"更改失败"];
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}


#pragma mark -- 限制输入字数
- (void) textFieldDidChange:(UITextField *)textField
{
    //最大长度
    NSInteger kMaxLength = 5;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            
            if (toBeString.length > kMaxLength) {
                
                textField.text = [toBeString substringToIndex:kMaxLength];
                [textField resignFirstResponder];
                
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
