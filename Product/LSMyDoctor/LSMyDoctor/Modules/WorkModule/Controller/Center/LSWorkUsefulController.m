//
//  LSWorkUsefulController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/14.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkUsefulController.h"

#import "LSWorkUsefulAddController.h"

@interface LSWorkUsefulController () <PWTagsViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PWTagsView *tagsView;

@end

@implementation LSWorkUsefulController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initForView];
    [self requestData];
    [self initForAction];
}

- (void)initForView
{
    self.navigationItem.title = @"常用语管理";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT-64)];
    [self.view addSubview:self.scrollView];
    
    self.dataArr = [NSMutableArray array];
    
    self.tagsView = [[PWTagsView alloc] initWithFrame:CGRectMake(0, 0, LSSCREENWIDTH, LSSCREENHEIGHT-64) delegate:self];
    [self.tagsView setDataArr:self.dataArr];
    [self.scrollView addSubview:self.tagsView];
}

- (void)initForAction
{
    __weak typeof(self) weakSelf = self;
    
    self.tagsView.btnBlock = ^(NSInteger index)
    {
        LSWorkUsefulAddController *vc = [[LSWorkUsefulAddController alloc] initWithNibName:@"LSWorkUsefulAddController" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        vc.dataDic = weakSelf.dataArr[index];

        vc.addBlock = ^(NSDictionary *dataDic) {
            [weakSelf.dataArr addObject:dataDic];
            [weakSelf.tagsView removeFromSuperview];
            [weakSelf.tagsView setDataArr:weakSelf.dataArr];
        };
        vc.deleteBlock = ^(NSDictionary *dataDic) {
            [weakSelf.dataArr removeObject:dataDic];
            [weakSelf.tagsView setDataArr:weakSelf.dataArr];
        };
    };
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:[Defaults valueForKey:@"cookie"] forKey:@"cookie"];
    [param setValue:[Defaults valueForKey:@"accessToken"] forKey:@"accessToken"];
    
    NSString *url = PATH(@"%@/chatCommon");
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.dataArr addObjectsFromArray:responseObj[@"data"]];
        [weakSelf.tagsView setDataArr:weakSelf.dataArr];
    } failBlock:^(NSError *error) {
        NSLog(@"");
    }];
}

- (void)rightItemClick
{ 
    LSWorkUsefulAddController *vc = [[LSWorkUsefulAddController alloc] initWithNibName:@"LSWorkUsefulAddController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    vc.addBlock = ^(NSDictionary *dataDic) {
        [self.dataArr addObject:dataDic];
        [self.tagsView setDataArr:self.dataArr];
    };
}

#pragma mark - PWTagsViewDelegate

- (void)getTagsViewHeight:(CGFloat)height
{
    self.scrollView.contentSize = CGSizeMake(LSSCREENWIDTH, height);
}

@end
