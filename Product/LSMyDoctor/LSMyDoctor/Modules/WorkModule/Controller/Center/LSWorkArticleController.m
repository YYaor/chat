//
//  LSWorkArticleController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleController.h"

#import "LSWorkArticleAddController.h"

#import "LSWorkArticleCell.h"
#import "LSCacheManager.h"
@interface LSWorkArticleController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, strong) UIButton *libraryBtn;
@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, strong) UIView *sliderView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *content;

@end

@implementation LSWorkArticleController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navView.hidden = NO;
    [self segmentBtnClick:self.manageBtn];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
}

- (void)initForView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.content = [NSMutableArray array];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar addSubview:self.navView];
    
    [self.tableView registerClass:[LSWorkArticleCell class] forCellReuseIdentifier:@"cell"];
}

- (void)rightItemClick
{
    LSWorkArticleAddController *vc = [[LSWorkArticleAddController alloc] initWithNibName:@"LSWorkArticleAddController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentBtnClick:(UIButton *)btn
{
    if (self.lastBtn == btn)
    {
        return;
    }
    
    if (self.lastBtn)
    {
        self.lastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.sliderView.frame = CGRectMake(LSX(btn), 41, LSWIDTH(btn), 2);
    
    
    self.lastBtn = btn;
    
    [self requestData];
}

- (void)requestData
{
    LSWEAKSELF;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@1 forKey:@"pagenum"];
    [param setValue:@100 forKey:@"pagesize"];
    
    NSString *url = @"";
    
    if (self.lastBtn == self.manageBtn)
    {
        //getArticleList 文章管理
        url = PATH(@"%@/collectArticleList");
    }
    else if (self.lastBtn == self.libraryBtn)
    {
        //collectArticleList 文章库
        url = PATH(@"%@/getArticleList");
    }
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            [weakSelf.content removeAllObjects];
            
            if (self.lastBtn == self.manageBtn) {
                NSArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"savearticle" WithPath:@"article"];
                if (saveArr) {
                    [weakSelf.content addObjectsFromArray:saveArr];
                    [weakSelf.content addObjectsFromArray:responseObj[@"data"][@"content"]];
                }
            }else{
                [weakSelf.content addObjectsFromArray:responseObj[@"data"][@"content"]];
            }
            
            [weakSelf.tableView reloadData];
        }else
        {
            [XHToast showCenterWithText:responseObj[@"message"]];
        }
    } failBlock:^(NSError *error) {
        //[XHToast showCenterWithText:@"fail"];
    }];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data =self.content[indexPath.section];
    if ([data[@"savetime"] doubleValue] > 0) {
        LSWorkArticleAddController *vc = [[LSWorkArticleAddController alloc] initWithNibName:@"LSWorkArticleAddController" bundle:nil];
        vc.data = data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSWorkArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.data = self.content[indexPath.section];
    
    cell.deleteBlock = ^(NSDictionary *dataDic) {
        if ([dataDic[@"isDraft"] integerValue] == 1) {
            //是草稿是就本地删除
            NSMutableArray *saveArr = [LSCacheManager unarchiverObjectByKey:@"savearticle" WithPath:@"article"];
            
            for (NSDictionary *dic in saveArr) {
                if ([self.content[indexPath.section][@"savetime"] doubleValue] == [dic[@"savetime"] doubleValue]) {
                    [saveArr removeObject:dic];
                }
            }
            
            [[LSCacheManager sharedInstance] removeObjectWithFilePath:@"article"];
            [[LSCacheManager sharedInstance] archiverObject:saveArr ByKey:@"savearticle" WithPath:@"article"];
            
            [self.content removeObject:dataDic];
            [self.tableView reloadData];

        }else{
            //不是草稿就是取消收藏
            NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
            
            [param setObject:[NSNumber numberWithInteger:[dataDic[@"id"] integerValue]] forKey:@"id"];
            NSString * url = PATH(@"%@/cancelCollectArticle");
            [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
                
                if (responseObj[@"status"] && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
                {
                    [self.content removeObject:dataDic];
                    [self.tableView reloadData];
                    
                }else
                {
                    [XHToast showCenterWithText:responseObj[@"message"]];
                }
            } failBlock:^(NSError *error) {
                //[XHToast showCenterWithText:@"fail"];
            }];

        }
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *data = self.content[indexPath.section];
    if ([data[@"type"] integerValue] == 4) {
        return 150;
    }else{
        return self.view.frame.size.width/3 + 150;
    }
}

#pragma mark - getter & setter

- (UIView *)navView
{
    if (!_navView)
    {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(LSSCREENWIDTH/4, 0, LSSCREENWIDTH/2, 44)];
        _navView.backgroundColor = [UIColor clearColor];
        
        [_navView addSubview:self.manageBtn];
        [_navView addSubview:self.libraryBtn];
        [_navView addSubview:self.sliderView];
    }
    return _navView;
}

- (UIButton *)manageBtn
{
    if (!_manageBtn)
    {
        _manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _manageBtn.frame = CGRectMake(0, 0, LSSCREENWIDTH/4, 44);
        _manageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _manageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manageBtn setTitle:@"文章管理" forState:UIControlStateNormal];
        [_manageBtn addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageBtn;
}

- (UIButton *)libraryBtn
{
    if (!_libraryBtn)
    {
        _libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _libraryBtn.frame = CGRectMake(LSSCREENWIDTH/4, 0, LSSCREENWIDTH/4, 44);
        _libraryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _libraryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_libraryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_libraryBtn setTitle:@"文章库" forState:UIControlStateNormal];
        [_libraryBtn addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _libraryBtn;
}

- (UIView *)sliderView
{
    if (!_sliderView)
    {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor whiteColor];
    }
    return _sliderView;
}

@end
