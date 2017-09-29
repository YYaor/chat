//
//  LSMineSettingController.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineSettingController.h"
#import "LSMineNewPswController.h"
#import "LSMineSettingCell.h"

@interface LSMineSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)AFAutoPurgingImageCache *imageCache;

@property (nonatomic,strong)NSString *cacheString;


@end

@implementation LSMineSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initNavView];
    [self initForView];
    [self getCacheSize];
}

-(void)getCacheSize{
   
    dispatch_after(0, dispatch_get_main_queue(), ^(void){

        float tmpSize = self.imageCache.memoryUsage;
        self.cacheString = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fMB",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        [self.dataTableView reloadData];
    });
}

//-(void)initNavView{
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
//    navView.backgroundColor = [UIColor colorFromHexString:LSGREENCOLOR];
//    [self.view addSubview:navView];
//    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backButton];
//    
//    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.font = [UIFont systemFontOfSize:18];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.text = @"设置";
//    titleLabel.backgroundColor = [UIColor clearColor];
//    [navView addSubview:titleLabel];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(navView);
//        make.centerY.equalTo(navView).offset(8);
//    }];
//}

-(void)initForView{
    
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.dataTableView];
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).offset(64);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSMineSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSMineSettingCell"];
    if(!cell){
        cell = [[LSMineSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSMineSettingCell"];
    }
    
    NSArray *titleArr = @[@"密码设置",@"版本信息",@"清除缓存"];
    if (indexPath.row == 0) {
        [cell updateCell:titleArr[indexPath.row] info:nil];
    }
    if (indexPath.row == 1) {
        [cell updateCell:titleArr[indexPath.row] info:@"V1.0.0"];
    }
    if (indexPath.row == 2) {
        [cell updateCell:titleArr[indexPath.row] info:self.cacheString];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LSMineNewPswController *newPswController = [[LSMineNewPswController alloc]init];
        [self.navigationController pushViewController:newPswController animated:YES];
    }
    if (indexPath.row == 2) {
        [self.imageCache removeAllImages];
        [self getCacheSize];
        [self.dataTableView reloadData];
    }
}


//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        _dataTableView.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    }
    return _dataTableView;
}

-(AFAutoPurgingImageCache *)imageCache{
    if (!_imageCache) {
        _imageCache = [[AFAutoPurgingImageCache alloc] init];
    }
    return _imageCache;
}

@end
