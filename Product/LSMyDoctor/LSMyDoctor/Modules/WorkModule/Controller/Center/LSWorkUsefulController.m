//
//  LSWorkUsefulController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUsefulController.h"

#import "LSWorkUsefulAddController.h"

#import "LSWorkUsefulCell.h"

@interface LSWorkUsefulController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation LSWorkUsefulController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.navigationItem.title = @"常用语管理";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.dataArr = [NSMutableArray array];
    [self.dataArr addObjectsFromArray:@[@"撒到佛教啊", @"撒到家哦教啊", @"撒到家哦大家佛教啊啊是大是大非开始的反馈速度疯狂的设计开发", @"撒到家哦大家佛教啊"]];
    
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 20;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 10;
    // 3.设置item块的大小 (可以用于自适应)
    layout.estimatedItemSize = CGSizeMake(20, 60);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    // 设置item的内边距
    layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    layout.estimatedItemSize = CGSizeMake(20, 60);
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT-64) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
    [self.collection registerClass:[LSWorkUsefulCell class] forCellWithReuseIdentifier:@"LSWorkUsefulCell"];
}

- (void)rightItemClick
{ 
    LSWorkUsefulAddController *vc = [[LSWorkUsefulAddController alloc] initWithNibName:@"LSWorkUsefulAddController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LSWorkUsefulCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSWorkUsefulCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

@end
