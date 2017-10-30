//
//  LSMineSettingController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineSettingController.h"
#import "LSMineNewPswController.h"
#import "LSMineSettingCell.h"

#import "SDImageCache.h"

@interface LSMineSettingController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *dataTableView;

@property (nonatomic,strong)AFAutoPurgingImageCache *imageCache;

@property (nonatomic,strong)NSString *cacheString;

@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation LSMineSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


-(void)initForView{
    
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.dataTableView];
    [self.view addSubview:self.sureButton];
    
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

-(void)sureButtonClick{
    //存在NSUserDefault中的有 isLogin doctorId cookie accessToken phoneNum
    
    [Defaults removeObjectForKey:@"isLogin"];
    [Defaults removeObjectForKey:@"doctorid"];
    [Defaults removeObjectForKey:@"cookie"];
    [Defaults removeObjectForKey:@"accessToken"];
    
    [Defaults synchronize];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSString* headUrl = [API_HOST substringToIndex:API_HOST.length - 3];
    NSString* url = [NSString stringWithFormat:@"%@/home/getAccessTokenEx",headUrl];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj)
    {
        if ([responseObj[@"status"] integerValue] == 0)
        {
            [Defaults setValue:responseObj[@"data"] forKey:@"accessToken"];
            NSLog(@"*******token:%@*****",responseObj[@"data"]);
            [Defaults synchronize];
            
            [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
                if (!aError) {
                    NSLog(@"退出登录成功");
                    
                    AppDelegate *app = LSAPPDELEGATE;
                    [app intoRootForLogin];
                }
            }];
            
            
        }
        else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    }
                              failBlock:^(NSError *error)
    {
        
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
        
        [[[UIAlertView alloc] initWithTitle:@"" message:@"是否清楚缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
    if (indexPath.row == 1) {
        [XHToast showCenterWithText:@"当前已是最新版本"];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.imageCache removeAllImages];
        [self getCacheSize];
        [self.dataTableView reloadData];
    }
}


-(UITableView *)dataTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
    }
    return _dataTableView;
}

-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
        [_sureButton setTitle:@"退出" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 20;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sureButton;
}

-(AFAutoPurgingImageCache *)imageCache{
    if (!_imageCache) {
        _imageCache = [[AFAutoPurgingImageCache alloc] init];
    }
    return _imageCache;
}

//#pragma mark -- 计算目录下文件（除去.data文件）大小
//- (NSString *)fileSizeForDir:(NSString*)path
//{
//    // 总大小
//    unsigned long long size = 0;
//    NSString *sizeText = @"0 B";
//    // 文件管理者
//    NSFileManager *mgr = [NSFileManager defaultManager];
//    
//    // 文件属性
//    NSDictionary *attrs = [mgr attributesOfItemAtPath:path error:nil];
//    // 如果这个文件或者文件夹不存在,或者路径不正确直接返回0;
//    if (attrs == nil) return [NSString stringWithFormat:@"%lluKB",size];
//    if ([attrs.fileType isEqualToString:NSFileTypeDirectory]) { // 如果是文件夹
//        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
//        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
//        for (NSString *subpath in enumerator) {
//            
//            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
//            
//            // 累加文件大小
//            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
//            
////            if ([subpath rangeOfString:@".data"].location == NSNotFound) {
////                NSLog(@"该名称为其他类型，例如文件夹或者非布局或非问卷文件");
////
////            } else {
////                //要删除的布局和问卷统计大小
////                // 全路径
////                NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
////
////                // 累加文件大小
////                size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
////
////
////            }
//            
//        }
//        
//        NSInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
//        size += tmpSize;
//        if (size >= pow(10, 9)) { // size >= 1GB
//            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
//        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
//            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
//        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
//            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
//        } else { // 1KB > size
//            sizeText = [NSString stringWithFormat:@"%zdB", size];
//        }
//        return sizeText;
//    } else { // 如果是文件
//        size = attrs.fileSize;
//        if (size >= pow(10, 9)) { // size >= 1GB
//            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
//        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
//            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
//        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
//            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
//        } else { // 1KB > size
//            sizeText = [NSString stringWithFormat:@"%zdB", size];
//        }
//        
//    }
//    return sizeText;
//}

@end
