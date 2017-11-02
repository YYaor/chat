//
//  YGReportCaseVC.m
//  YouGeHealth
//
//  Created by 惠生 on 17/1/16.
//
//

#import "YGReportCaseVC.h"
#import "YYMGroup.h"

@interface YGReportCaseVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* hospitalCaseTab;
    UIImageView* markImgView;//绿色标记
    NSInteger rowNum;//多少行
    NSMutableArray *dataMutArr;
    NSArray* titleArr;
    
}

@property (nonatomic,strong) NSMutableArray *qnIdArr;//问卷Id数组
@property (nonatomic,strong) NSMutableArray *dateMultArr;//日期列表数组
@property (nonatomic,assign) NSInteger timeNum;//时间


@end

@implementation YGReportCaseVC

#pragma mark -- 懒加载
- (NSMutableArray *)qnIdArr{
    
    if (_qnIdArr == nil) {
        _qnIdArr = [NSMutableArray array];
        
    }
    return _qnIdArr;
}
- (NSMutableArray *)dateMultArr{
    
    if (_dateMultArr == nil) {
        _dateMultArr = [NSMutableArray array];
        
    }
    return _dateMultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"住院病历";
    self.view.backgroundColor = Style_Color_Content_BGColor;
    
    NSString* yearStr  = [self.timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    NSString* monthStr  = [yearStr stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    NSString* dayStr  = [monthStr stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    self.timeNum = [dayStr integerValue];
    
    if (!dataMutArr) {
        dataMutArr = [NSMutableArray array];
    }
    
    if (!titleArr) {
        titleArr = [[NSArray alloc] initWithObjects:@"入院记录",@"病程记录", @"出院记录",  nil];
    }
    
    
    
    
    
    // Todo: 加载数据模型(后台请求的数据)
    //    NSArray *groupNames = @[@[@"2016年3月12日",@"2010年10月4日",@"2012年8月8日"],@[],@[@"陆小凤",@"陆依萍",@"李云龙",@"李自成"]];
    //    //这是一个分组的模型类
    //    for (NSMutableArray *name in groupNames) {
    //        YYMGroup *group1 = [[YYMGroup alloc] initWithDates:name];
    //        [dataMutArr addObject:group1];
    //    }
    
    
    
    //创建View
    [self creatHospitalCaseView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取门急诊列表
    [self getDateData];
}


#pragma mark -- 创建View
- (void)creatHospitalCaseView
{
    
    
    UIView* timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 60)];
    timeView.backgroundColor = UIColorFromRGB(0xf0fbff);
    [self.view addSubview:timeView];
    
    //时间框前的标记
    UIImageView* timeImgView = [[UIImageView alloc] init];
    timeImgView.contentMode = UIViewContentModeScaleAspectFit;
    timeImgView.image = [UIImage imageNamed:@"note"];
    [timeView addSubview:timeImgView];
    [timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView.mas_centerY);
        make.left.equalTo(timeView.mas_left).offset(20);
        make.height.equalTo(timeView.mas_height).multipliedBy(0.5);
        make.width.equalTo(timeImgView.mas_height);
    }];
    
    //时间文本框
    UILabel* timeLab = [[UILabel alloc] init];
    timeLab.textColor = Style_Color_Content_Blue;
    timeLab.text = [self timeChangeWithTimeString:self.timeStr];//转换格式
    timeLab.font = [UIFont systemFontOfSize:20];
    [timeView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView.mas_centerY);
        make.left.equalTo(timeImgView.mas_right).offset(5);
    }];
    
    //创建tableView
    hospitalCaseTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 60, kScreenWidth, kScreenHeight - 64 - 60) style:UITableViewStyleGrouped];
    hospitalCaseTab.delegate = self;
    hospitalCaseTab.dataSource = self;
    [self.view addSubview:hospitalCaseTab];
    
}

#pragma mark -- tableViewDelegate/tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataMutArr.count > 0) {
        YYMGroup *group = dataMutArr[section];
        NSInteger num = group.size;
        if (group.size <= 0) {
            num = 0;
        }else{
            num  = group.size ;
        }
        return group.isFolded? 0: num;
    }else{
        return 0;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //绿色标记
    markImgView = [[UIImageView alloc] init];
    //    markLab.backgroundColor = UIColorFromRGB(0x3eca65);
    [headerView addSubview:markImgView];
    [markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(30);
        make.height.equalTo(headerView.mas_height).multipliedBy(0.3);
        make.width.equalTo(markImgView.mas_height);
    }];
    
    markImgView.layer.cornerRadius = 4;
    markImgView.layer.borderWidth = 1.0f;
    markImgView.layer.borderColor = UIColorFromRGB(0x3eca65).CGColor;
    
    if (dataMutArr.count > 0) {
        YYMGroup *group = dataMutArr[section];
        if (group.dates.count >= 1) {
            //有项，则显示绿标记
            markImgView.image = [UIImage imageNamed:@"title_green"];
            
        }else{
            
            markImgView.image = [UIImage imageNamed:@""];
            
        }
    }else{
        
        markImgView.image = [UIImage imageNamed:@""];
    }
    
    
    //显示名称
    
    UILabel* caseNameLab = [[UILabel alloc] init];
    caseNameLab.textColor = Style_Color_Content_Black;
    caseNameLab.text = titleArr[section];
    [headerView addSubview:caseNameLab];
    [caseNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(markImgView.mas_right).offset(10);
    }];
    
    //headerView按钮
    UIButton* headerViewBtn = [[UIButton alloc] init];
    [headerViewBtn addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    //根据模型里面的展开还是收起变换图片
    if (dataMutArr.count > 0  && section == 1) {
        YYMGroup *group = dataMutArr[section];
        if (group.isFolded==YES) {
            //未展开，向右
            [headerViewBtn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
        }else{
            //展开，向下
            [headerViewBtn setImage:[UIImage imageNamed:@"down_public"] forState:UIControlStateNormal];
        }
    }else{
        [headerViewBtn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
    }
    
    
    
    headerViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headerViewBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,20)];
    headerViewBtn.tag = section;
    [headerView addSubview:headerViewBtn];
    [headerViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.textColor = Style_Color_Content_Black;
    //将模型里的数据赋值给cell
//    YYMGroup *group = dataMutArr[indexPath.section];
//    NSArray *arr=group.dates;
    
    cell.textLabel.text = [self timeChangeWithTimeString:self.dateMultArr[indexPath.row]];
    
    [cell.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(50);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    cell.imageView.image = [UIImage imageNamed:@""];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击tableView");
    //病程记录点击方法

    UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
    CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
    reportVC.module = @"Case_Hospitalization";
    reportVC.userIdStr = self.userIdStr;
    reportVC.date = [self.dateMultArr[indexPath.row] integerValue];
    reportVC.isHiddenDateLabel = YES;
    reportVC.reportId = @"102";
    reportVC.lifeDiaryDetailStr = @"100";
    [self.navigationController pushViewController:reportVC animated:YES];
    
    
    
}


#pragma mark -- 入院记录、病程记录、出院记录点击方法
- (void)headerViewClick:(UIButton*)sender
{
    NSInteger indexSection =  sender.tag;
    NSLog(@"点击headerView：%ld",(long)indexSection);
    //改变模型数据里面的展开收起状态
    if(indexSection == 0){
        //入院记录
        UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
        CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
        reportVC.module = @"Case_BeHospitalized";
        if (self.timeNum) {
            reportVC.date = self.timeNum;
        }else{
            reportVC.date = [NSDate getCurrentDate];
        }
        reportVC.userIdStr = self.userIdStr;
        reportVC.isHiddenDateLabel = YES;
        reportVC.reportId = @"102";
        reportVC.lifeDiaryDetailStr = @"100";
        [self.navigationController pushViewController:reportVC animated:YES];
    }else{
        //首先判断入院有没有填写
        YYMGroup *group1 = dataMutArr[0];
        if (group1.dates.count < 1) {
            //说明没有数据
//            [XHToast showBottomWithText:@"请先填写入院记录"];
            return;
            
        }
        
        
        if (indexSection == 1) {
            //病程记录
            YYMGroup *group2 = dataMutArr[indexSection];
            group2.folded = !group2.isFolded;
            [hospitalCaseTab reloadData];
            
        }else{
            //出院记录
            YYMGroup *group = dataMutArr[2];
            NSString* leaveTimeStr = self.timeStr;
            for (NSDictionary* dict in group.dates) {
                if (dict[@"saveSate"]) {
                    leaveTimeStr = dict[@"saveSate"];
                }
                
            }
            
            UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
            CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
            reportVC.module = @"Case_LeaveHospital";
            reportVC.userIdStr = self.userIdStr;
            reportVC.date = [leaveTimeStr integerValue];
            reportVC.isHiddenDateLabel = YES;
            reportVC.reportId = @"102";
            reportVC.lifeDiaryDetailStr = @"100";
            [self.navigationController pushViewController:reportVC animated:YES];
            
        
        }
        
        
        

    }
    
    
}

#pragma mark -- 获取入院、病程、出院病历列表
- (void)getDateData
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:AccessToken forKey:@"accessToken"];
    [param setValue:@(self.qnCodeNum) forKey:@"qncode"];
    [param setValue:self.userIdStr forKey:@"userId"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)self.timeNum] forKey:@"saveDate"];
    
    NSString* url = [NSString stringWithFormat:@"%@/case/getHospitalizedList",UGAPI_HOST];
    
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        NSLog(@"returnData:-------%@",responseObj);
        if (responseObj && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            //返回正确值
            NSLog(@"%@",responseObj[@"data"]);
            
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                
                [dataMutArr removeAllObjects];
                
                NSArray* arr = responseObj[@"data"];
                for (NSDictionary* dict in arr) {
                    
                    if ([dict[@"dates"] isKindOfClass:[NSArray class]]) {
                        NSArray* name = dict[@"dates"];
                        YYMGroup *group1 = [[YYMGroup alloc] initWithDates:name];
                        [dataMutArr addObject:group1];
                        
                    }
                    //把qnId放置数组中
                    [self.qnIdArr addObject:[NSString stringWithFormat:@"%@",dict[@"qnid"]]];
                    
                }
                
                YYMGroup *groupModel = dataMutArr[1];//病程记录
                self.dateMultArr = [self timeStrInArray:groupModel.dates];
                
                
            }
            
            
            [hospitalCaseTab reloadData];
            
            
        }else{
            //查询数据失败
            NSString* string = [NSString stringWithFormat:@"查询数据失败:%@",responseObj[@"status"]];
            [XHToast showBottomWithText:string];
            
        }

    } failBlock:^(NSError *error) {
        [XHToast showBottomWithText:@"加载失败"];
        NSLog(@"error:%@",error);
    }];
    
    
    
    
    
}


#pragma mark -- 取出时间
- (NSMutableArray*)timeStrInArray:(NSArray*)dataArr
{
    NSMutableArray* timeMultArr = [NSMutableArray array];
    NSLog(@"%@",dataArr);
    for (NSDictionary* dict in dataArr) {
        if (dict[@"saveSate"]) {
            NSString * timeStr = dict[@"saveSate"];
            [timeMultArr addObject:timeStr];
        }
        
    }
    
    return timeMultArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 20170102转换为2017年01月02日方法
- (NSString*)timeChangeWithTimeString:(NSString*)time
{
    if (time.length >= 8) {
        NSString* year = [time substringToIndex:4];
        NSRange range = {4,2};
        NSString* month = [time substringWithRange:range];
        NSString* day = [time substringFromIndex:6];
        
        return [NSString stringWithFormat:@"%@年%@月%@日",year , month , day];
    }else{
        return time;
    }
    
    
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
