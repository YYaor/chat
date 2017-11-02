//
//  YGReportDateVC.m
//  YouGeHealth
//
//  Created by 惠生 on 17/1/13.
//
//

#import "YGReportDateVC.h"
#import "YGReportCaseVC.h"//住院病历跳转

@interface YGReportDateVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* reportTab;
    
}
@property (nonatomic,strong) NSMutableArray *dataMutArr;//日期列表数组

@end

@implementation YGReportDateVC

#pragma mark -- 懒加载
- (NSMutableArray *)dataMutArr{
    
    if (_dataMutArr == nil) {
        _dataMutArr = [NSMutableArray array];
        
    }
    return _dataMutArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Style_Color_Content_BGColor;
    [self getDateData];
    [self creatTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取门急诊列表
//    [self getDateData];
}

#pragma mark -- 勾勒tableView
- (void)creatTableView
{
    reportTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    reportTab.delegate = self;
    reportTab.dataSource = self;
    reportTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:reportTab];
    [reportTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
}
#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataMutArr.count > 0) {
        
        return _dataMutArr.count;
        
    }else{
        
        return 0;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMutArr.count > 0) {
        
        UILabel* dateLab = [[UILabel alloc] init];
        dateLab.layer.cornerRadius = 6.0f;
        dateLab.layer.borderWidth = 1.0f;
        dateLab.layer.borderColor = BarColor.CGColor;
        dateLab.tag = 10000+indexPath.row;
        dateLab.textColor = BarColor;
        dateLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:dateLab];
        [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(cell.mas_height).multipliedBy(0.8);
            make.width.equalTo(cell.mas_width).multipliedBy(0.8);
        }];
        NSString* dateString = self.dataMutArr[indexPath.row];
        
        if (dateString.length >= 8) {
            NSString* year = [dateString substringToIndex:4];
            NSRange range = {4,2};
            NSString* month = [dateString substringWithRange:range];
            NSString* day = [dateString substringFromIndex:6];
            
            dateLab.text = [NSString stringWithFormat:@"%@年%@月%@日",year , month , day];
        }else{
            dateLab.text = self.dataMutArr[indexPath.row];
        }

        
        
        
    }
    
    
    
    return cell;
}

#pragma mark -- 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击日历跳转");
    NSString* dateStr = self.dataMutArr[indexPath.row];
    
    if ([self.applayoutCode isEqualToString:@"B112003"]) {
        //住院病历
        YGReportCaseVC* reportCaseVC = [[YGReportCaseVC alloc] init];
        reportCaseVC.timeStr = dateStr;
        reportCaseVC.qnCodeNum = self.qnCodeNum;
        reportCaseVC.userIdStr = self.userIdStr;
        [self.navigationController pushViewController:reportCaseVC animated:YES];
        
        
    }else{
        //其他跳转报告
        UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
        CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
        reportVC.module = self.module;
        reportVC.userIdStr = self.userIdStr;
        reportVC.date = [dateStr integerValue];
        reportVC.isHiddenDateLabel = YES;
        reportVC.lifeDiaryDetailStr = @"100";
        reportVC.reportId = @"102";
        [self.navigationController pushViewController:reportVC animated:YES];
    }
    
    
}

#pragma mark -- 获取住院病历列表
- (void)getDateData
{
    [self.dataMutArr removeAllObjects];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:AccessToken forKey:@"accessToken"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)self.qnCodeNum] forKey:@"qncode"];
    [param setValue:self.userIdStr forKey:@"userId"];
    
    
    NSString* url = @"/case/getBeHospitalizedDate";
    
    if ([self.applayoutCode isEqualToString:@"B112002"]) {
        //门急诊病历
        url = @"/case/getOutpationDepartmentDate";
    }else if ([self.applayoutCode isEqualToString:@"B112003"]){
        //住院病历
        url = @"/case/getBeHospitalizedDate";
    }else if ([self.applayoutCode isEqualToString:@"B112004"]){
        //体检报告
        url = @"/case/getCheckDate";
    }else{
        //其他
        
    }
    
    NSString* getUrl = [NSString stringWithFormat:@"%@%@",UGAPI_HOST,url];
    
    [TLAsiNetworkHandler requestWithUrl:getUrl params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        NSLog(@"returnData:-------%@",responseObj);
        if (responseObj && [[NSString stringWithFormat:@"%@",responseObj[@"status"]] isEqualToString:@"0"])
        {
            //返回正确值
            NSLog(@"%@",responseObj[@"data"]);
            
            if ([responseObj[@"data"] isKindOfClass:[NSArray class]]) {
                
                NSArray* arr = [NSArray arrayWithArray:responseObj[@"data"]];
                //往按钮里面添加数据
                for (NSDictionary* dict in arr) {
                    NSString* str = [NSString stringWithFormat:@"%@",dict[@"SaveDate"]];
                    
                    [self.dataMutArr addObject:str];
                    
                }
                
            }
            if (self.dataMutArr.count <= 0) {
                //没有填写过
                reportTab.hidden = YES;
                //显示您还未填写报告
                [self creatNoReportView];
                
                
            }else{
                //存在报告
                reportTab.hidden = NO;
                [reportTab reloadData];
            }
            
            
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



#pragma mark -- 如果未填写过该项报告，显示您还未填写内容
- (void)creatNoReportView
{
    //显示空白的图片
    UIImageView* blankImgView = [[UIImageView alloc] init];
    blankImgView.image = [UIImage imageNamed:@"nomessage"];
    blankImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:blankImgView];
    [blankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-150);
        make.height.equalTo(@120);
        make.width.equalTo(blankImgView.mas_height).multipliedBy(0.8);
    }];
    //显示提示语句
    UILabel* nomessageLab = [[UILabel alloc] init];
    nomessageLab.text = @"您还没有报告";
    nomessageLab.textColor = UIColorFromRGB(0xa0a0a0);
    [self.view addSubview:nomessageLab];
    [nomessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blankImgView.mas_centerX);
        make.top.equalTo(blankImgView.mas_bottom).offset(10);
    }];
    
    
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
