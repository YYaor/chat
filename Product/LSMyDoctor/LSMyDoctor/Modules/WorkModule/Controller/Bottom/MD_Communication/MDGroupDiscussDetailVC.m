//
//  MDGroupDiscussDetailVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDGroupDiscussDetailVC.h"
#import "MDNewDiscussCell.h"
#import "MDAllMemberReusableView.h"//查看群成员
#import "MDGroupNameCell.h"
#import "LSChooseMateController.h"
#import "MDGroupDetailModel.h"//群组详情

@interface MDGroupDiscussDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView* discussCol;
}

@property (nonatomic ,strong)MDGroupDetailModel* groupDetailModel;

@end

@implementation MDGroupDiscussDetailVC

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
    
    [discussCol registerNib:[UINib nibWithNibName:@"MDAllMemberReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mDAllMemberReusableView"];//查看所有群成员
    
    [discussCol registerNib:[UINib nibWithNibName:@"MDGroupNameCell" bundle:nil] forCellWithReuseIdentifier:@"mDGroupNameCell"];//群组名称
    
    discussCol.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:discussCol];
    
    UIButton* deleteGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, LSSCREENHEIGHT - 50 - 64, LSSCREENWIDTH - 60, 40)];
    [deleteGroupBtn setTitle:@"解散此群" forState:UIControlStateNormal];
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
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        //群成员
        if (self.groupDetailModel.users.count > 6) {
            return 8;
        }else{
            return self.groupDetailModel.users.count + 2;
        }
        
    }else{
        return 1;
    }
    
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((LSSCREENWIDTH - 35)/4, ((LSSCREENWIDTH - 35)*6)/(4*5));
    }else{
        return CGSizeMake(LSSCREENWIDTH, 50);
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MDAllMemberReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mDAllMemberReusableView" forIndexPath:indexPath];
    view.userInteractionEnabled = YES;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 0){
        //只有section == 0时存在查看所有群成员
        UIButton* allMemberBtn = [[UIButton alloc] init];
        [allMemberBtn setTitle:@"查看所有群成员 > " forState:UIControlStateNormal];
        [allMemberBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [allMemberBtn addTarget:self action:@selector(allMemberBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allMemberBtn];
        [allMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(view);
        }];
        
        
    }
    return view;
}

#pragma mark -- 查看群成员按钮点击
- (void)allMemberBtnClick
{
    NSLog(@"查看群成员按钮点击");
}

// 返回区头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(LSSCREENWIDTH, 5.0f);
    }else{
        return CGSizeMake(LSSCREENWIDTH, 0.000001f);
    }
}
//返回区footer的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        //查看所有群成员
        return CGSizeMake(LSSCREENWIDTH, 30);
    }else{
        return CGSizeMake(LSSCREENWIDTH, 0.000001f);
    }
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
        }else if (indexPath.item == 7){//最后一个
            cell.userImgView.image = [UIImage imageNamed:@"more"];
            cell.userNameLab.text = @"";
        }else{
            //加过来的好友
            MDGroupUserModel* userModel = self.groupDetailModel.users[indexPath.item - 1];
            
            cell.userNameLab.text = userModel.doctor_name;
            
            
        }
        
        return cell;
        
    }else{
        //群置顶
        MDGroupNameCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mDGroupNameCell" forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            //群组名称
            cell.cellNameLab.text = @"群组名称";
            UIImageView* rightImgView = [[UIImageView alloc] init];
            rightImgView.image = [UIImage imageNamed:@"right_white_Public"];
            rightImgView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.baseView addSubview:rightImgView];
            [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.baseView.mas_right).offset(-8);
                make.centerY.equalTo(cell.baseView.mas_centerY);
            }];
            
            UILabel* groupNameLab = [[UILabel alloc] init];
            groupNameLab.text = @"高血压";
            groupNameLab.textColor = [UIColor grayColor];
            [cell.baseView addSubview:groupNameLab];
            [groupNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.baseView.mas_centerY);
                make.right.equalTo(rightImgView.mas_left).offset(-8);
            }];
            
            
        }else{
            //置顶群
            cell.cellNameLab.text = @"置顶群";
            UISwitch* topSwitch = [[UISwitch alloc] init];
            topSwitch.onTintColor = BaseColor;
            [topSwitch addTarget:self action:@selector(topSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:topSwitch];
            [topSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-15);
            }];
            
            
            
        }
        
        return cell;
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"选择讨论对象");
        if (indexPath.item == 7) {
            //点击最后一个加号
            NSLog(@"点击添加好友");
            LSChooseMateController *chooseMateVC = [[LSChooseMateController alloc] init];
            chooseMateVC.chooseBlock = ^(NSArray *modelArray) {
                //TO——DO 重新获取群详情
                
            };
            [self.navigationController pushViewController:chooseMateVC animated:YES];
            
        }else{
            //点击添加的用户个人资料
        }
        
    }else if (indexPath.section == 1){
        //修改群组名称
        
    }else{
        //群置顶
    }
    
}

#pragma mark -- 置顶群开关操作
- (void)topSwitchChanged:(UISwitch*)sender
{
    NSString* str = sender.on ? @"开关打开" : @"开关关闭";
    NSLog(@"%@",str);
}

#pragma mark  -- 获取讨论组详情
- (void)getGroupDetailRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:self.groupIdStr forKey:@"roomid"];
    
    NSString* url = PATH(@"%@/queryRoomInfo");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                self.groupDetailModel = [MDGroupDetailModel yy_modelWithDictionary:responseObj[@"data"]];
                
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



@end
