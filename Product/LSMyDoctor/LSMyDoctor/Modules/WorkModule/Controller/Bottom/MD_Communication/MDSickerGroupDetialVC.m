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

@interface MDSickerGroupDetialVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView* discussCol;
}
@property (nonatomic ,strong)MDSickerGroupDetailModel* groupDetailModel;

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
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/..%@",API_HOST,@"imgurl"]];
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
    NSLog(@"置顶选择%@",sender.on);
//    [self changeSickerDetailWithisFocus:sender.isOn];
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

@end
