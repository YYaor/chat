//
//  LSBeginChatController.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSBeginChatController.h"
#import "LSPatientModel.h"
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
    
    [self initForView];
    [self loadData];
}

-(void)initForView{
    UIView *chooseMateView = [self getChooseMateView];
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

-(void)loadData{
    LSPatientModel *model1 = [[LSPatientModel alloc]init];
    model1.name = @"张三";
    model1.sex = @"男";
    model1.age = @"10";
    model1.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";
    
    LSPatientModel *model2 = [[LSPatientModel alloc]init];
    model2.name = @"李四";
    model2.sex = @"女";
    model2.age = @"10";
    model2.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";
    
    
    LSPatientModel *model3 = [[LSPatientModel alloc]init];
    model3.name = @"王五";
    model3.sex = @"男";
    model3.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";
    //    model3.age = @"15";
    
    LSPatientModel *model4 = [[LSPatientModel alloc]init];
    model4.name = @"李四四";
    model4.sex = @"女";
    model4.age = @"134";
    model4.goodAt = @"擅长：儿童先天性修复儿童先天性修复儿童先天性修复";
    
    
    [self.dataArray addObject:model1];
    [self.dataArray addObject:model2];
    [self.dataArray addObject:model3];
    [self.dataArray addObject:model4];
    
    [self.dataCollectionView reloadData];
}


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
    moreImage.image = [UIImage imageNamed:@"back_g"];
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
            cell.clodeBlock = ^(LSPatientModel *model) {
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

-(void)addButtonClick{
    
}

-(void)nextButtonClick{
    //开始讨论
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

