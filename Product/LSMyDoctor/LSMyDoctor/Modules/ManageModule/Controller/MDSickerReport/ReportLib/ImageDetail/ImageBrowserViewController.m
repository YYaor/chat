//
//  ImageBrowserViewController.m
//  ImageBrowser
//
//  Created by msk on 16/9/1.
//  Copyright © 2016年 msk. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "PhotoView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ImageBrowserViewController ()<UIScrollViewDelegate,PhotoViewDelegate>{
    
    NSMutableArray *_subViewArray;//scrollView的所有子视图
    
    UIView *topView;//顶部试图
    UIButton *backBtn;//返回按钮
    UIButton *deleteBtn;//删除按钮
}
@property(nonatomic,copy) NSString *picUrl;//传过来的图片的地址
/** 背景容器视图 */
@property(nonatomic,strong) UIScrollView *scrollView;

/** 外部操作控制器 */
@property (nonatomic,weak) UIViewController *handleVC;

/** 图片浏览方式 */
@property (nonatomic,assign) PhotoBroswerVCType type;

/** 图片数组 */
@property (nonatomic,strong) NSArray *imagesArray;

/** 初始显示的index */
@property (nonatomic,assign) NSUInteger index;

/** 圆点指示器 */
@property(nonatomic,strong) UIPageControl *pageControl;

/** 记录当前的图片显示视图 */
@property(nonatomic,strong) PhotoView *photoView;

@end

@implementation ImageBrowserViewController

-(instancetype)init{
    
    self=[super init];
    if (self) {
        _subViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor=[UIColor blackColor];
    
    //去除自动处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(WIDTH * self.imagesArray.count, 0);
    
    for (int i = 0; i < self.imagesArray.count; i++) {
        [_subViewArray addObject:[NSNull class]];
    }
    
    self.scrollView.contentOffset = CGPointMake(WIDTH*self.index, 0);//此句代码需放在[_subViewArray addObject:[NSNull class]]之后，因为其主动调用scrollView的代理方法，否则会出现数组越界
    
    if (self.imagesArray.count==1) {
        _pageControl.hidden=YES;
    }else{
        self.pageControl.currentPage=self.index;
    }
    
    [self loadPhote:self.index];//显示当前索引的图片
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrentVC:)];
    [self.view addGestureRecognizer:tap];//为当前view添加手势，隐藏当前显示窗口
    
    //顶部添加视图
    [self setTopView];
}

////隐藏状态栏
//- (BOOL)prefersStatusBarHidden{
//    
//    return YES;
//}

- (void)setTopView{
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 30)];
    [backBtn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    if ([_handleVC isKindOfClass:[CureReportViewController class]]) {
        
        //报告
    }else{
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 68, 5, 60, 30)];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [topView addSubview:deleteBtn];
    }
    
    
}

-(void)hideCurrentVC:(UIGestureRecognizer *)tap{
    //[self hideScanImageVC];
    [self changeTopViewIsHidden];
}

#pragma 返回、删除按钮点击事件
- (void)backBtnClicked:(UIButton *) backBtn{
    
    [self hideScanImageVC];
}
- (void)deleteBtnClicked:(UIButton *) deleteBtn{
    
    [AlertHelper InitMyAlertWithTitle:@"" AndMessage:@"确认删除该图片？" And:self CanCleBtnName:@"取消" SureBtnName:@"确认" AndCancleBtnCallback:^(id data) {
        
        //取消
        
    } AndSureBtnCallback:^(id data) {
        
        //确认
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeletePicReload" object:self.picUrl];
        [self hideScanImageVC];
    }];
    
    
}

#pragma mark - 显示图片
-(void)loadPhote:(NSInteger)index{
    
    if (index<0 || index >=self.imagesArray.count) {
        return;
    }
    id currentPhotoView = [_subViewArray objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        //url数组或图片数组
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        if ([[self.imagesArray firstObject] isKindOfClass:[UIImage class]]) {
            PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoImage:[self.imagesArray objectAtIndex:index]];
            photoV.delegate = self;
            [self.scrollView insertSubview:photoV atIndex:0];
            [_subViewArray replaceObjectAtIndex:index withObject:photoV];
            self.photoView=photoV;
        }else if ([[self.imagesArray firstObject] isKindOfClass:[NSString class]]){
            PhotoView *photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imagesArray objectAtIndex:index]];
            photoV.delegate = self;
            [self.scrollView insertSubview:photoV atIndex:0];
            [_subViewArray replaceObjectAtIndex:index withObject:photoV];
            self.photoView=photoV;
        }
    }
}

#pragma mark - 生成显示窗口
+(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type index:(NSUInteger)index picUrl:(NSString *)url imagesBlock:(NSArray *(^)())imagesBlock{
    
    NSArray *photoModels = imagesBlock();//取出相册数组
    
    if(photoModels == nil || photoModels.count == 0) {
        return;
    }
    
    ImageBrowserViewController *imgBrowserVC = [[self alloc] init];
    
    if(index >= photoModels.count){
        return;
    }
    
    imgBrowserVC.picUrl = url;
    imgBrowserVC.index = index;
    
    imgBrowserVC.imagesArray = photoModels;
    
    imgBrowserVC.type =type;
    
    imgBrowserVC.handleVC = handleVC;
    
    [imgBrowserVC show]; //展示
}

/** 真正展示 */
-(void)show{
    
    switch (_type) {
        case PhotoBroswerVCTypePush://push
            
            [self pushPhotoVC];
            
            break;
        case PhotoBroswerVCTypeModal://modal
            
            [self modalPhotoVC];
            
            break;
            
        case PhotoBroswerVCTypeZoom://zoom
            
            [self zoomPhotoVC];
            
            break;
            
        default:
            break;
    }
}

/** push */
-(void)pushPhotoVC{
    
    [_handleVC.navigationController pushViewController:self animated:YES];
}


/** modal */
-(void)modalPhotoVC{
    
    [_handleVC presentViewController:self animated:YES completion:nil];
}

/** zoom */
-(void)zoomPhotoVC{
    
    //拿到window
    UIWindow *window = _handleVC.view.window;
    
    if(window == nil){
        NSLog(@"错误：窗口为空！");
        return;
    }
    
    self.view.frame=[UIScreen mainScreen].bounds;
    
    [window addSubview:self.view]; //添加视图
    
    [_handleVC addChildViewController:self]; //添加子控制器
}

#pragma mark - 隐藏当前显示窗口
-(void)hideScanImageVC{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    switch (_type) {
        case PhotoBroswerVCTypePush://push
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        case PhotoBroswerVCTypeModal://modal
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
            
        case PhotoBroswerVCTypeZoom://zoom
            
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page<0||page>=self.imagesArray.count) {
        return;
    }
    self.pageControl.currentPage = page;
    
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[PhotoView class]]) {
            PhotoView *photoV=(PhotoView *)[_subViewArray objectAtIndex:page];
            if (photoV!=self.photoView) {
                [self.photoView.scrollView setZoomScale:1.0 animated:YES];
                self.photoView=photoV;
            }
        }
    }
    
    [self loadPhote:page];
}

#pragma mark - PhotoViewDelegate
-(void)tapHiddenPhotoView{
    //[self hideScanImageVC];//隐藏当前显示窗口
    
    [self changeTopViewIsHidden];
}

//是否隐藏topView
- (void)changeTopViewIsHidden{
    
    BOOL yyy = topView.hidden;
    if (topView.hidden) {
        
        topView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            topView.center = CGPointMake(topView.center.x, 20);
            
        }completion:^(BOOL finished) {
            
            
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            topView.center = CGPointMake(topView.center.x, -20);
        }completion:^(BOOL finished) {
            
            topView.hidden = YES;
        }];
    }
}

#pragma mark - 懒加载
-(UIScrollView *)scrollView{
    
    if (_scrollView==nil) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        _scrollView.contentOffset=CGPointZero;
        //设置最大伸缩比例
        _scrollView.maximumZoomScale=3;
        //设置最小伸缩比例
        _scrollView.minimumZoomScale=1;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (_pageControl==nil) {
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-40, WIDTH, 30)];
        bottomView.backgroundColor=[UIColor clearColor];
        _pageControl = [[UIPageControl alloc] initWithFrame:bottomView.bounds];
        _pageControl.currentPage = self.index;
        _pageControl.numberOfPages = self.imagesArray.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:153 green:153 blue:153 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:235 green:235 blue:235 alpha:0.6];
        [bottomView addSubview:_pageControl];
        [self.view addSubview:bottomView];
    }
    return _pageControl;
}

#pragma mark - 系统自带代码
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
