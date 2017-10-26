//
//  LSBeginChatController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSBeginChatController.h"
#import "MDChooseSickerVC.h"
#import "LSChooseMateController.h"
#import "MDDoctorListModel.h"
#import "LSAddDocCollectionCell.h"
@interface LSBeginChatController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *dataCollectionView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)UIButton *nextButton;

@end

@implementation LSBeginChatController

-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
        [_nextButton setTitle:@"开始讨论" forState:UIControlStateNormal];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 20;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nextButton;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起讨论";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initForView];
//    [self loadData];
}

- (void)initForView{
    //选择讨论对象
    UIView *chooseMateView = [self getChooseMateView];
    chooseMateView.userInteractionEnabled = YES;
    [chooseMateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePatientView)]];
    [self.view addSubview:chooseMateView];
    [chooseMateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"邀请同行";
    title.textColor = [UIColor colorFromHexString:@"333333"];
    [chooseMateView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(14);
        make.top.equalTo(chooseMateView.mas_bottom).offset(14);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    self.dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.dataCollectionView];
    self.dataCollectionView.backgroundColor = [UIColor whiteColor];
    self.dataCollectionView.alwaysBounceVertical = YES;
    self.dataCollectionView.showsVerticalScrollIndicator = NO;
    self.dataCollectionView.showsHorizontalScrollIndicator = NO;
    self.dataCollectionView.bounces = NO;
    [self.dataCollectionView registerClass:[LSAddDocCollectionCell class] forCellWithReuseIdentifier:@"LSAddDocCollectionCell"];
    [self.dataCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"addView"];

    //4.设置代理
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.dataSource = self;
    
    [self.dataCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
        make.top.equalTo(title.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark -- 选择讨论对象
-(UIView *)getChooseMateView{
    
    UIView *chooseMateView = [[UIView alloc]init];
    
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"选择讨论对象";
    title.textColor = [UIColor colorFromHexString:@"333333"];
    [chooseMateView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(chooseMateView);
        make.left.equalTo(chooseMateView).offset(14);
    }];
    
    UIImageView *moreImage = [[UIImageView alloc]init];
    moreImage.image = [UIImage imageNamed:@"right_white_Public"];
    [chooseMateView addSubview:moreImage];
    [moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 19));
        make.centerY.equalTo(chooseMateView);
        make.right.equalTo(chooseMateView).offset(-14);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    [chooseMateView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_left);
        make.bottom.right.equalTo(chooseMateView);
        make.height.mas_equalTo(1);
    }];
    
    return chooseMateView;
}
#pragma mark -- 添加邀请同行
-(UIView *)addView{
    UIView *addView = [UIView new];
    UIButton *addbutton = [[UIButton alloc]init];
    [addbutton setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addbutton];

    [addbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addView);
        make.centerY.equalTo(addView).offset(-13);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    return addView;
}

#pragma mark - UICollectionViewDelegate
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX(1, self.dataArray.count+1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0) {
        if (indexPath.row < self.dataArray.count) {
            LSAddDocCollectionCell *cell = (LSAddDocCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LSAddDocCollectionCell" forIndexPath:indexPath];
            cell.model = self.dataArray[indexPath.row];
            
            __weak typeof(self) weakSelf = self;
            cell.clodeBlock = ^(MDDoctorListModel *model) {
                [weakSelf.dataArray removeObject:model];
                [weakSelf.dataCollectionView reloadData];
            };
            
            return cell;
        }else{
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addView" forIndexPath:indexPath];
            UIView *addView = [self addView];
            [cell.contentView addSubview:addView];
            
            [addView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.left.bottom.equalTo(cell.contentView);
            }];
            [self.view layoutIfNeeded];
            return cell;
        }
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addView" forIndexPath:indexPath];
        UIView *addView = [self addView];
        [cell.contentView addSubview:addView];
        
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.left.bottom.equalTo(cell.contentView);
        }];
        [self.view layoutIfNeeded];

        return cell;
    }
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 90);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 25, 0, 25);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- 添加按钮点击
-(void)addButtonClick{
    LSChooseMateController *chooseMateVC = [[LSChooseMateController alloc] init];
    chooseMateVC.chooseBlock = ^(NSArray *modelArray) {
        [self.dataArray addObjectsFromArray:modelArray];
        [self.dataCollectionView reloadData];
    };
    [self.navigationController pushViewController:chooseMateVC animated:YES];
}
#pragma mark -- 开始讨论按钮点击
-(void)nextButtonClick
{
    //开始讨论
    NSLog(@"开始讨论按钮点击");
    [self creatDiscussRoomData];
}
#pragma mark -- 选择讨论对象按钮点击
-(void)choosePatientView{
    
    MDChooseSickerVC *chooseSickerVC = [[MDChooseSickerVC  alloc]init];
    
    [self.navigationController pushViewController:chooseSickerVC animated:YES];
}

#pragma mark -- 创建讨论组并开始讨论
- (void)creatDiscussRoomData
{
    
    NSMutableArray* doctorMultArr = [NSMutableArray array];
    [doctorMultArr removeAllObjects];
    for (MDDoctorListModel* model in self.dataArray) {
        [doctorMultArr addObject:model.doctor_id];
    }
    NSString *doctorIdsStr = [doctorMultArr componentsJoinedByString:@","];
    
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:doctorIdsStr forKey:@"doctorids"];
    [param setValue:@(170) forKey:@"userid"];
    [param setValue:@"ceshib" forKey:@"username"];
    
    NSString* url = PATH(@"%@/createRoom");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            
            if ([[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
            {
                //TO--DO创建房间成功 ，跳转群组会话页面
                
                
                
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

