//
//  MDSickerGroupDetialVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/31.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDSickerGroupDetialVC.h"
#import "MDNewDiscussCell.h"
#import "MDSickerGroupDetailModel.h"//患者群组的详情
#import "MDAddGroupVC.h"//患者添加群患者
#import "MDGroupNameCell.h"

@interface MDSickerGroupDetialVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    UICollectionView* discussCol;
    UITextField* inputTF;//输入群组名称
}
@property (nonatomic ,strong)MDSickerGroupDetailModel* groupDetailModel;
@property (nonatomic , strong)UIView*           getView;//点击领取弹出背景层

@end

@implementation MDSickerGroupDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUi];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getGroupDetailRequest];
}
#pragma mark -- 创建界面
- (void)setUpUi
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((LSSCREENWIDTH - 35)/4, ((LSSCREENWIDTH - 35)*6)/(4*5));
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    
    //创建界面
    discussCol = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT - 60 - 64) collectionViewLayout:layout];
    discussCol.backgroundColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR];
    discussCol.delegate = self;
    discussCol.dataSource = self;
    
    [discussCol registerNib:[UINib nibWithNibName:@"MDNewDiscussCell" bundle:nil] forCellWithReuseIdentifier:@"mDNewDiscussCell"];//群组成员
    [discussCol registerNib:[UINib nibWithNibName:@"MDGroupNameCell" bundle:nil] forCellWithReuseIdentifier:@"mDGroupNameCell"];//置顶群、修改群组名称
    
    discussCol.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:discussCol];
    
    UIButton* deleteGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 64, LSSCREENWIDTH - 60, 40)];
    [deleteGroupBtn setTitle:@"解散讨论组" forState:UIControlStateNormal];
    [deleteGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteGroupBtn setBackgroundColor:BaseColor];
    [deleteGroupBtn addTarget:self action:@selector(deleteGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    deleteGroupBtn.layer.masksToBounds = YES;
    deleteGroupBtn.layer.cornerRadius = 6.0f;
    [self.view addSubview:deleteGroupBtn];
    
}
#pragma mark -- 解散此群按钮点击
- (void)deleteGroupBtnClick
{
    NSLog(@"解散此群");
    
    [self deleteGroupData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.groupDetailModel.users.count + 2 ;
    }else{
        return 1;
    }
    
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((LSSCREENWIDTH - 35)/4, ((LSSCREENWIDTH - 35)*6)/(4*5));
    }else{
        return CGSizeMake(LSSCREENWIDTH, 50);
    }
    
    
}

// 返回区头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(LSSCREENWIDTH, 10.0f);
    }
    return CGSizeMake(LSSCREENWIDTH, 0.000001f);
}
//返回区footer的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(LSSCREENWIDTH, 0.000001f);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MDNewDiscussCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mDNewDiscussCell" forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            //我的头像
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/..%@",API_HOST,@"imgurl"]];
            [cell.userImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImg_public"]];
            cell.userNameLab.text = @"我";
        }else{
            //加过来的好友
            if (indexPath.item == self.groupDetailModel.users.count + 1) {
                cell.userImgView.image = [UIImage imageNamed:@"more"];
                cell.userNameLab.text = @"";
            }else{
                MDSickerGroupUserModel* userModel = self.groupDetailModel.users[indexPath.item - 1];
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/..%@",API_HOST,userModel.img_url]];
                [cell.userImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImg_public"]];
                cell.userNameLab.text = userModel.username;
                
            }
            
            
            
        }
        
        return cell;
    }else{
        //重命名
        
        MDGroupNameCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mDGroupNameCell" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            cell.cellNameLab.text = @"重命名";
            UIImageView* rightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_white_Public"]];
            rightImgView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.baseView addSubview:rightImgView];
            [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.baseView.mas_centerY);
                make.right.equalTo(cell.baseView.mas_right).offset(-10);
                
            }];
            UILabel* valueLab = [[UILabel alloc] init];
            valueLab.text = self.groupDetailModel.name;
            valueLab.textColor = [UIColor darkGrayColor];
            [cell.baseView addSubview:valueLab];
            [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.baseView.mas_centerY);
                make.right.equalTo(rightImgView.mas_left).offset(-10);
            }];
            
        }else{
            cell.cellNameLab.text = @"置顶群";
            UISwitch* isImportantSwitch = [[UISwitch alloc] init];
            isImportantSwitch.on = [self.groupDetailModel.is_stick boolValue];
            isImportantSwitch.onTintColor = BaseColor;
            [isImportantSwitch addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:isImportantSwitch];
            [isImportantSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-15);
            }];
        }
        
        return cell;
    }
   
}
#pragma mark -- 是否置顶
- (void)switchBtnClick:(UISwitch*)sender
{
    [self changeToTopWithStick:sender.isOn];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.item == self.groupDetailModel.users.count + 1) {
            //点击最后一个加号
            NSLog(@"点击添加好友");
            
            MDAddGroupVC* addGroupVC = [[MDAddGroupVC alloc] init];
            addGroupVC.submitData = YES;
            addGroupVC.groupDetailModel  = self.groupDetailModel;
            addGroupVC.groupIdStr = self.groupIdStr;
            [self.navigationController pushViewController:addGroupVC animated:YES];
            
            
        }else if (indexPath.item == 0){
            //点击我
        }else{
            //点击添加的用户个人资料
            
        }
    }else if (indexPath.section == 1){
        //点击群组名称
        NSLog(@"点击群组名称");
        
        
        
        
    }
    
    
    
}

#pragma mark -- 修改群组名点击弹出View
- (void)changeGroupName
{
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
    //请输入群组名
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
    //修改群组名称
    [self changeGroupNameRequestData];
    
}





#pragma mark  -- 获取讨论组详情
- (void)getGroupDetailRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.groupIdStr forKey:@"groupid"];
    
    NSString* url = PATH(@"%@/queryGroupInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                
                self.groupDetailModel = [MDSickerGroupDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                
                [discussCol reloadData];
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
#pragma mark  -- 删除群
- (void)deleteGroupData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.groupIdStr forKey:@"groupid"];
    NSString* url = PATH(@"%@/deleteDoctorGroup");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                //解散成功
                UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                
                [self.navigationController popToViewController:vc animated:YES];
                
                
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
#pragma mark -- 修改群用户名操作
- (void)changeGroupNameRequestData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:inputTF.text forKey:@"name"];
    [param setValue:self.groupIdStr forKey:@"groupid"];
    
    NSString* url = PATH(@"%@/updateDoctorGroup");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self getGroupDetailRequest];
            
        }else
        {
            [XHToast showCenterWithText:@"更改失败"];
        }
    } failBlock:^(NSError *error) {
        [XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark -- 修改是否置顶操作
- (void)changeToTopWithStick:(BOOL)stick
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@(stick) forKey:@"is_stick"];
    [param setValue:self.groupIdStr forKey:@"groupid"];
    
    NSString* url = PATH(@"%@/updateDoctorGroup");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [self getGroupDetailRequest];
            
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
