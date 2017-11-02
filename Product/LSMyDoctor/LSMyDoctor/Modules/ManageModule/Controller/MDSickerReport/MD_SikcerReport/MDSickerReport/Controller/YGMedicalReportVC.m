//
//  YGMedicalReportVC.m
//  YouGeHealth
//
//  Created by 惠生 on 17/1/12.
//
//

#import "YGMedicalReportVC.h"
#import "WFSegTitleView.h"
#import "YGReportDateVC.h"

@interface YGMedicalReportVC ()
{
    UIView* bodyView;//下面View
    NSString* moduleStr;
    WFSegTitleView *titleView;
}

@property (nonatomic,strong) NSMutableArray *titleArray;//头部菜单栏标题
@property (nonatomic,strong) AppLayoutModel *layoutModel;
@property (nonatomic,strong) WFLayoutHelper *layoutHelper;
@property (nonatomic,strong) NSMutableArray *medicalLayoutArray;//布局数组
@property (nonatomic,strong) YGReportDateVC* reportDateVC;//报告日历页面

@end

@implementation YGMedicalReportVC

#pragma mark -- 懒加载

- (NSMutableArray *)titleArray{
    
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)medicalLayoutArray{
    
    if (_medicalLayoutArray == nil) {
        _medicalLayoutArray = [NSMutableArray array];
    }
    return _medicalLayoutArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者病历";
    self.view.backgroundColor = Style_Color_Content_BGColor;
    moduleStr = @"Case_BaseInfo";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self getTitleData];
}

#pragma mark -- 创建View
- (void)creatMediclReportVC
{
    
    titleView = [[WFSegTitleView alloc] initWithItems:self.titleArray];
    titleView.frame = CGRectMake(0, 65, kScreenWidth, 40);
    titleView.showLine = YES;//是否显示分割线
    
    [titleView addTarget:self action:@selector(titleBtnclick:)];
    [self.view addSubview:titleView];
    
    [titleView tabDidSelectTabAtIndex:self.selectedSegmentIndex];
    
    bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 + 40 + 2, kScreenWidth, kScreenHeight - 65 - 42)];
    
    bodyView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bodyView];
    
//   [self jumpTitleViewWithIndex:self.selectedSegmentIndex];
    
}
#pragma mark -- 头部菜单栏显示
- (void)titleBtnclick: (WFSegTitleView*)segView
{
    NSInteger index = segView.selectedSegmentIndex;
//    NSLog(@"点击按钮%@",self.titleArray[index]);
    self.selectedSegmentIndex = index;
    
    [self jumpTitleViewWithIndex:index];
    
}

- (void)jumpTitleViewWithIndex:(NSInteger)index
{
    
    if (index == 0) {
        //基础信息报告，直接拿报告页面
        
        moduleStr = @"Case_BaseInfo";
        [self addReportVC];
        
        
    }else{
        //门急诊病历、住院病历、体检报告均显示日历
        if (index == 1) {
            //门急诊病历
            moduleStr = @"Case_OutpatientDepartment";
        }else if(index == 2){
            //住院病历
            moduleStr = @"";
        }else{
            //体检报告
            moduleStr = @"Case_PhysicalExamination";
            
        }
        [self loadDateListVCWithIndex:index];
        
    }
    
}

#pragma mark -- 直接加载报告
- (void)addReportVC
{
    //清空子视图
    for(UIView *view in [bodyView subviews])
    {
        [view removeFromSuperview];
    }
    
    UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
    CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
    reportVC.module = @"Case_BaseInfo";
    reportVC.userIdStr = self.userIdStr;
    reportVC.date = [NSDate getCurrentDate];
    reportVC.isHiddenDateLabel = YES;
    reportVC.reportId = @"101";
    reportVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104);
    [self addChildViewController:reportVC];
    [bodyView addSubview:reportVC.view];
    
    
}

#pragma mark -- 加载日历列表
- (void)loadDateListVCWithIndex:(NSInteger)index
{
    //清空子视图
    for(UIView *view in [bodyView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    ModulesModel* models = self.medicalLayoutArray[index];
    _reportDateVC = [[YGReportDateVC alloc] init];
    _reportDateVC.applayoutCode = models.appLayoutCode;
    if (index == 0) {
        //我的基本信息
    }else if (index == 1){
        //门急诊
        _reportDateVC.qnCodeNum = 702;
    }else if (index == 2){
        //住院
        _reportDateVC.qnCodeNum = 703;
    }else{
        //体检报告
        _reportDateVC.qnCodeNum = 704;
    }
    _reportDateVC.userIdStr = self.userIdStr;
    _reportDateVC.module = moduleStr;
    _reportDateVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104);
    [self addChildViewController:_reportDateVC];
    [bodyView addSubview:_reportDateVC.view];
    
}


#pragma mark -- 请求数据
- (void)getTitleData
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:AccessToken forKey:@"accessToken"];
    [param setValue:@(0) forKey:@"series"];
    
    NSString* url = [NSString stringWithFormat:@"%@/getLayout/medicalrecord",UGAPI_HOST];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        NSLog(@"returnData:-------%@",responseObj);
        if (responseObj) {
            if ([(NSDictionary *)[responseObj[@"data"] valueForKey:@"modules"] count] > 0) {
                
                //NSLog(@"模块版本信息：%@",returnData);
                _layoutModel = [AppLayoutModel yy_modelWithDictionary:responseObj[@"data"]];
                //归档
                
                [NSKeyedArchiver archiveRootObject:_layoutModel toFile:kFilePath(@"MyMedicalRecordLayout.data")];
                [self.medicalLayoutArray addObjectsFromArray:_layoutModel.modules.data];
                
            }else{
                
                NSLog(@"无须更新");
                //读取本地
                _layoutModel = [_layoutHelper getAppLayoutModel];
                
                [self.medicalLayoutArray addObjectsFromArray:_layoutModel.modules.data];
                
                
            }
            
            NSLog(@"%@",self.medicalLayoutArray);
            
            for (ModulesModel* models in self.medicalLayoutArray) {
                [self.titleArray addObject:models.appLayoutName];
            }
            
            
        }
        
        
        
        [self creatMediclReportVC];
        

    } failBlock:^(NSError *error) {
        [XHToast showBottomWithText:@"加载失败"];
        NSLog(@"error:%@",error);
    }];
    
    
    
}
- (void)tuichu:(NSInteger) index
{
    NSLog(@"通知消息已经到达。。。");
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
