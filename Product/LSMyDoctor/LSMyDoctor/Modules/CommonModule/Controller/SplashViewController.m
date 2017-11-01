//
//  SplashViewController.m
//  CrossFire
//
//  Created by 王飞 on 16/7/15.
//  Copyright © 2016年 王飞. All rights reserved.
//

#import "SplashViewController.h"
#import "GuidePageModel.h"
#import "YGPageControl.h"

@interface SplashViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (nonatomic,strong) YGPageControl *pageControl;

@end

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //加载app版本信息
    [self loadAppVersion ];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    
    
    //加载引导页
    //[self LeadIngPageUrlRequest];
    
}

-(void)notice:(id)sender{
    NSLog(@"********************");
    NSLog(@"%@",sender);
}

- (void) setScrollViewWithImagesArray:(NSArray *) images{
    
//    self.scrollView.contentSize = CGSizeMake(images.count * LSSCREENWIDTH+LSSCREENWIDTH, LSSCREENHEIGHT);
    self.scrollView.contentSize = CGSizeMake(images.count * LSSCREENWIDTH, LSSCREENHEIGHT);
    self.scrollView.delegate = self;
    
//    _pageControl = [[YGPageControl alloc] initWithFrame:CGRectMake(0, LSSCREENHEIGHT - 60, LSSCREENWIDTH, 30)];
//    //设置圆点个数
//    _pageControl.numberOfPages = images.count;
//    _pageControl.currentPage = 0;
//    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    _pageControl.currentPageIndicatorTintColor = RGBCOLOR(255, 198, 122);
    
//    [self.view addSubview:_pageControl];
    
    //添加图片控件
    for (int i = 0; i < images.count; ++i) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * LSSCREENWIDTH, 0, LSSCREENWIDTH, LSSCREENHEIGHT)];
         GuidePageModel *guideModel = images[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:guideModel.picture]];
        
        [self.scrollView addSubview:imageView];
        
        UIButton *btnIn = [UIButton buttonWithType:UIButtonTypeSystem];
        btnIn.titleLabel.font = [UIFont systemFontOfSize:17];
        btnIn.layer.borderColor = [UIColor colorFromHexString:LSGREENCOLOR].CGColor;
        btnIn.layer.borderWidth = 1;
        [btnIn addTarget:self action:@selector(toMainControllerView) forControlEvents:UIControlEventTouchUpInside];
        btnIn.backgroundColor = [UIColor whiteColor];
        imageView.userInteractionEnabled = YES;
        [imageView addSubview:btnIn];

        if (i == images.count - 1) {
            if (LSSCREENHEIGHT < 667) {
                btnIn.frame = CGRectMake((LSSCREENWIDTH - 120)/2, LSSCREENHEIGHT - 105, 100, 30);
            }else{
                btnIn.frame = CGRectMake((LSSCREENWIDTH - 120)/2, LSSCREENHEIGHT * 5 / 6, 120, 35);
            }
            
            [btnIn setTitleColor:[UIColor colorFromHexString:LSGREENCOLOR] forState:UIControlStateNormal];
            [btnIn setTitle:@"立即体验" forState:UIControlStateNormal];
            btnIn.layer.cornerRadius = 5;

        }else{
            btnIn.frame = CGRectMake(LSSCREENWIDTH - 100, 30, 80, 30);
            [btnIn setTitle:@"进入" forState:UIControlStateNormal];
            [btnIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnIn.layer.cornerRadius = 15;
//            btnIn.backgroundColor = [UIColor redColor];
        }
    }
}
#pragma mark - 引导页加载
- (void)LeadIngPageUrlRequest
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *param = [MDRequestParameters shareRequestParameters];
    
    [param setValue:@0 forKey:@"deviceType"];
    [param setObject:@2 forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@/home/loadGuides",UGAPI_HOST];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        NSDictionary *returnData = responseObj;
        if (returnData && returnData[@"data"]) {
            NSArray *guidesArr = [NSArray yy_modelArrayWithClass:[GuidePageModel class] json:[returnData[@"data"] objectForKey:@"guides"]];
            //设置引导页
//            [[[GuidePageView alloc]initViewWithImageUrls:guidesArr] show];
            [self setScrollViewWithImagesArray:guidesArr];
        }

    } failBlock:^(NSError *error) {
        [AlertHelper InitMyAlertWithMessageAndBlock:@"请检查您的网络" And:self AndCallback:^(id data) {
            [weakSelf toMainControllerView];
        }];
        NSLog(@"引导页请求失败:%@",error);
    }];
}

- (void)toMainControllerView{
    
    //将其设为根视图控制器
//    TabBarViewController *tabVC = [[TabBarViewController alloc]init];
//    UINavigationController * navMain = [[UINavigationController alloc] initWithRootViewController:tabVC];
//    [UIApplication sharedApplication].delegate.window.rootViewController = navMain;
    
    AppDelegate *app = LSAPPDELEGATE;
    
    if ([Defaults objectForKey:@"isLogin"])
    {
        [app intoRootForMain];
    }
    else
    {
        [app intoRootForLogin];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    NSInteger index = scrollView.contentOffset.x/ScreenW;
//    _pageControl.currentPage = index;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    int index = (int) (scrollView.contentOffset.x / LSSCREENWIDTH + 0.5);
//    _pageControl.currentPage = index;
//    
//    NSInteger nu = ceilf((float)(scrollView.contentOffset.x / LSSCREENWIDTH));
//    
//    if ( nu + 1 > _pageControl.numberOfPages) {
//        //当最后一个是滑动跳转
//        [self toMainControllerView];
//    }
//    
//}

//加载app版本信息
- (void)loadAppVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@0 forKey:@"deviceType"];
    [param setValue:app_Version forKey:@"currentVersion"];
    [param setValue:AccessToken forKey:@"accessToken"];
    
    NSString *url = [NSString stringWithFormat:@"%@/home/loadAppVersion",UGAPI_HOST];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if (responseObj) {
            NSInteger status = [responseObj[@"status"] integerValue];
            if (status == 0) {
                NSDictionary *dict = responseObj[@"data"];
                BOOL hasNewVersion = [dict[@"hasNewVersion"] boolValue];
                if (hasNewVersion) {
                    //有新版本
                    NSString *updateLog = dict[@"updateLog"];//更新的日志
                    NSString *newVersion = dict[@"newVersion"];//更新的版本号
                    NSLog(@"%@ == %@",newVersion,updateLog);
                    BOOL isMandatory = [dict[@"isMandatory"] boolValue];
                    NSString *btnName = @"确定";
                    if (isMandatory) {
                        //强制更新
                        btnName = @"更新";
                        [AlertHelper InitMyAlertWithTitle:@"更新" AndMessage:@"当前版本过低，请更新后继续使用！" And:self btnName:btnName AndCallback:^(id data) {
                            
                            if (isMandatory) {
                                //强制更新
                                NSURL *url = [NSURL URLWithString:uploadNewAppUrl];
                                [[UIApplication sharedApplication] openURL:url];
                            }else{
                                [self LeadIngPageUrlRequest]; //引导页请求
                            }
                        }];
                    }else{
                        //非强制更新
                        [AlertHelper InitMyAlertWithTitle:@"更新" AndMessage:@"有新版本发布，是否更新？" And:self CanCleBtnName:@"取消" SureBtnName:@"更新" AndCancleBtnCallback:^(id data) {
                            
                            //取消
                            [self LeadIngPageUrlRequest]; //引导页请求

                        } AndSureBtnCallback:^(id data) {
                            
                            //更新
                            NSURL *url = [NSURL URLWithString:uploadNewAppUrl];
                            [[UIApplication sharedApplication] openURL:url];
                        }];
                        
                    }
                    
                    
                }else{
                    //无新版本
                    [self LeadIngPageUrlRequest]; //引导页请求
                }
            }else{
                [self LeadIngPageUrlRequest]; //引导页请求
            }
        }else{
            [self LeadIngPageUrlRequest]; //引导页请求
        }
        
    } failBlock:^(NSError *error) {
        
        NSLog(@"加载app版本信息失败：%@",error);
        [self LeadIngPageUrlRequest]; //引导页请求
    }];
}

@end
