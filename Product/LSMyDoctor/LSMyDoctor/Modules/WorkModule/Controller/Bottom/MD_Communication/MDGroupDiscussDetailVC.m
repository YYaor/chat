//
//  MDGroupDiscussDetailVC.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDGroupDiscussDetailVC.h"
#import "MDNewDiscussCell.h"
#import "LSChooseMateController.h"
#import "MDGroupDetailModel.h"//同行讨论组详情

@interface MDGroupDiscussDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView* discussCol;
}

@property (nonatomic ,strong)MDGroupDetailModel* groupDetailModel;

@end

@implementation MDGroupDiscussDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讨论组信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setUpUi];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getGroupDetailRequest];
}
- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString* myIdStr = [NSString stringWithFormat:@"%@",[Defaults valueForKey:@"doctorid"]];
    if (![[NSString stringWithFormat:@"%@",self.groupDetailModel.doctor_id] isEqualToString:myIdStr]) {
        [XHToast showCenterWithText:@"对不起，您没有权限解散"];
        return;
    }
    
    [self deleteGroupData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupDetailModel.users.count + 1 ;
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((LSSCREENWIDTH - 35)/4, ((LSSCREENWIDTH - 35)*6)/(4*5));
    return CGSizeMake((LSSCREENWIDTH - 35)/4, ((LSSCREENWIDTH - 35)*1.2)/4);
    
}

// 返回区头的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(LSSCREENWIDTH, 0.000001f);
}
//返回区footer的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(LSSCREENWIDTH, 0.000001f);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDNewDiscussCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mDNewDiscussCell" forIndexPath:indexPath];
    //加过来的好友
    if (indexPath.item == self.groupDetailModel.users.count) {
        cell.userImgView.image = [UIImage imageNamed:@"more"];
        cell.userNameLab.text = @"";
    }else{
        MDGroupUserModel* userModel = self.groupDetailModel.users[indexPath.item ];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/..%@",API_HOST,userModel.doctor_image]];
        [cell.userImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImg_public"]];
        cell.userNameLab.text = userModel.doctor_name;
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item == self.groupDetailModel.users.count) {
        //点击最后一个加号
        NSLog(@"点击添加好友");
        
        LSChooseMateController *chooseMateVC = [[LSChooseMateController alloc] init];
        chooseMateVC.submitData = YES;
        chooseMateVC.groupDetailModel  = self.groupDetailModel;
        chooseMateVC.groupIdStr = self.groupIdStr;
        [self.navigationController pushViewController:chooseMateVC animated:YES];
        
    }else if (indexPath.item == 0){
        //点击我
    }else{
        //点击添加的用户个人资料
        
    }
    
    
}

#pragma mark  -- 获取讨论组详情
- (void)getGroupDetailRequest
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    //同行的讨论组
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
#pragma mark  -- 删除讨论组
- (void)deleteGroupData
{
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    [param setValue:self.groupIdStr forKey:@"roomid"];
    
    NSString* url = PATH(@"%@/deleteDoctorRoom");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                //解散成功
                [XHToast showCenterWithText:@"解散成功"];
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
