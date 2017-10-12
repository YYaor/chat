//
//  LSWorkArticleController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleController.h"

#import "LSWorkArticleAddController.h"

@interface LSWorkArticleController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, strong) UIButton *libraryBtn;
@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, strong) UIView *sliderView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LSWorkArticleController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navView.hidden = NO;
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar addSubview:self.navView];
    
    [self segmentBtnClick:self.manageBtn];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lastBtn == self.manageBtn)
    {
        return 10;
    }
    else
    {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
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
