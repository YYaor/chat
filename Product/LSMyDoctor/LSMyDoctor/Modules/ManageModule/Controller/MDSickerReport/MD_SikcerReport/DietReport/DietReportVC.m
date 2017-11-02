//
//  DietReportVC.m
//  YouGeHealth
//
//  Created by yunzujia on 16/10/26.
//
//

#import "DietReportVC.h"
#import "DietReportCell.h"
#import "DietReportTrigleCell.h"
#import "DietDefine.h"

#import "DietReportHeadCell.h"
#import "YGReportT06TableViewCell.h"
#import "YGReportT05TableViewCell.h"

@interface DietReportVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *noMessageView;

@property (weak, nonatomic ) IBOutlet       UILabel        *dateLabel;
@property (weak, nonatomic ) IBOutlet       UILabel        *yougeMarkLabel;
@property (weak, nonatomic ) IBOutlet       UILabel        *scrotitle;
@property (weak, nonatomic ) IBOutlet       UILabel        *needtitle;
@property (weak, nonatomic ) IBOutlet       UIButton       *detailbtn;

@property (weak, nonatomic ) IBOutlet       UILabel        *needToEatLabel;
@property (weak, nonatomic ) IBOutlet       UITableView    *reportTableView;


//雷达图数据在dataDictionary中的位置
@property (nonatomic, assign) NSInteger radarIndex;

@end

static NSString* cellReusedIDForT06Cell = @"cellReusedIDForT06Cell";
static NSString* cellReusedIDForT05Cell = @"cellReusedIDForT05Cell";

@implementation DietReportVC

#pragma mark - UIViewController

- (NSMutableArray<DRGItemModel *> *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (void)dealloc
{
    NSLog(@"饮食报告控制器消亡");
}

- (void)viewDidLoad {
    NSLog(@"DietReportVC - viewDidLoad");
    [super viewDidLoad];
    self.noMessageView.alpha = 0;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.detailbtn.titleLabel.textColor = UIColorFromRGB(0x5593e8);
    self.detailbtn.layer.borderWidth = 1.5;
    self.detailbtn.layer.masksToBounds = YES;
    self.detailbtn.layer.cornerRadius = 3;
    self.detailbtn.layer.borderColor = UIColorFromRGB(0x5593e8).CGColor;
    if ([self.qnCode isEqualToString:@"2"]) {
        //简版跳转 不显示详情按钮
        self.detailbtn.hidden = YES;
    }else{
        self.detailbtn.hidden = NO;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"饮食报告";
    
    if ([self.reportTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.reportTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.reportTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.reportTableView setLayoutMargins:UIEdgeInsetsZero];
    }

    self.reportTableView.delegate   = self;
    self.reportTableView.dataSource = self;
    
    [self.reportTableView registerNib:[UINib nibWithNibName:@"DietReportCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.reportTableView registerClass:[DietReportTrigleCell class] forCellReuseIdentifier:@"cell1"];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"DietReportHeadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"rehead"];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"YGReportT06TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier: cellReusedIDForT06Cell];
    [self.reportTableView registerNib:[UINib nibWithNibName:@"YGReportT05TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier: cellReusedIDForT05Cell];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"DietReportVC - viewWillAppear");
    [super viewWillAppear:animated];
    NSDateFormatter * fomat = [[NSDateFormatter alloc] init];
    [fomat setDateFormat:@"yyyy年M月d日"];
    NSString * dataStr = @"";
    
    if (self.date) {
        NSString* timeStr = [NSString stringWithFormat:@"%ld",(long)self.date];
        if (timeStr.length == 8) {
            dataStr = [self timeChangeWithTimeString:timeStr];
        }else{
            dataStr = timeStr;
        }
        
    }else{
        dataStr = [fomat stringFromDate:self.foodDate];
    }
    self.dateLabel.text = dataStr;
    [self loadReport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    if (section != self.radarIndex)
    {
        count = self.dataArray[section].data.list.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != self.radarIndex ? 112 : kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section != self.radarIndex)
    {
        height = 92;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 非雷达图部分，返回有效Header
    UIView *view = nil;
    if (section != self.radarIndex)
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"DietReportHeadCell" owner:self options:nil] objectAtIndex:0];
        
        DietReportHeadCell *cell = (DietReportHeadCell*) view;
        DRGItemModel *model = self.dataArray[section];
        
        cell.headerTitle = model.caption.text;
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell;
    
    if (indexPath.section == self.radarIndex)
    {
        NSArray<ListT06T05Model *> *datas = self.dataArray[indexPath.section].data.list;
        YGReportT05TableViewCell *realCell = [self.reportTableView dequeueReusableCellWithIdentifier:cellReusedIDForT05Cell];
        if (realCell == nil)
        {
            realCell = [[YGReportT05TableViewCell alloc] init];
        }
        
        // datas的排放顺序是：早餐、午餐、晚餐
        // 对应的坐标轴：x-晚餐，y-午餐，z-早餐
        
        realCell.namex = datas[2].name;
        realCell.namey = datas[1].name;
        realCell.namez = datas[0].name;
        
        realCell.standardx = datas[2].std;
        realCell.standardy = datas[1].std;
        realCell.standardz = datas[0].std;
        
        realCell.x = datas[2].value;
        realCell.y = datas[1].value;
        realCell.z = datas[0].value;
        
        cell = realCell;
    }
    else
    {
        NSArray<ListT06T05Model *> *datas = self.dataArray[indexPath.section].data.list;
        ListT06T05Model *model = datas[indexPath.row];
        
        YGReportT06TableViewCell *realCell = [self.reportTableView dequeueReusableCellWithIdentifier:cellReusedIDForT06Cell];
        if (realCell == nil)
        {
            realCell = [[YGReportT06TableViewCell alloc] init];
        }
        
        realCell.name = model.name;
        realCell.unit = model.unit;
        realCell.minValue = model.min;
        realCell.maxValue = model.max;
        realCell.yourMaxValue = model.std_max;
        realCell.yourMinValue = model.std_min;
        realCell.yourValue = model.value;
        
        cell = realCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - Private Methods

- (void) loadReport
{
    NSDateFormatter * fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"yyyyMMdd"];
    NSString * datestr = @"";
    if (self.date) {
        datestr = [NSString stringWithFormat:@"%ld",(long)self.date];
        
    }else{
        datestr = [fo stringFromDate:self.foodDate];
    }
    NSMutableDictionary * mDict = [[NSMutableDictionary alloc] init];
    NSString * userKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    
    [mDict setObject:@"daily" forKey:@"cycle"];
    if (datestr) {
        [mDict setObject:datestr forKey:@"date"];
        
    }else{
        [XHToast showCenterWithText:@"日期为空"];
    }
    
    [mDict setObject:@"LiveDiary_Food" forKey:@"module"];
    if (userKey) {
        [mDict setObject:userKey forKey:@"userKey"];
    }
    
    [mDict setObject:AccessToken forKey:@"accessToken"];
    
    NSLog(@"DietReportVC 请求数据参数：%@", mDict);
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", DIET_COMMON, DIET_REPORT];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:urlStr parameters:mDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DietReportModel * model = [DietReportModel yy_modelWithJSON:responseObject];
        
        //NSLog(@"DietReportVC 请求数据成功，响应结果 : %@", responseObject);
        //NSLog(@"DietReportVC 请求数据成功，响应JSON: %@", dict);
        
        if (model.data.header != nil && model.data.header.length > 0)
        {
            self.dateLabel.text = model.data.header;
        }
        if (model.data.IsSimple == 1) {
            //是简版报告
            self.detailbtn.hidden = YES;
        }
        
        if (model.data.groups.count > 0)
        {
            // 清空旧数据
            [self.dataArray removeAllObjects];
            
            for (int i = 0; i < model.data.groups.count; ++ i)
            {
                // 整理数据
                DRGItemModel *drgItemModel = model.data.groups[i].items[0];
                if (drgItemModel != nil )
                {
                    NSString *reporterType = drgItemModel.type;
                    DRGDataModel *data = drgItemModel.data;
                    if ([reporterType isEqualToString:@"T22"])
                    {
                        self.yougeMarkLabel.text = [NSString stringWithFormat:@"%ld", data.left_value];
                        self.needToEatLabel.text = [NSString stringWithFormat:@"%ld", data.right_value];
                    }
                    else
                    {
                        if ([reporterType isEqualToString:@"T05"])
                        {
                            self.radarIndex = self.dataArray.count;
                        }
                        
                        [self.dataArray addObject:drgItemModel];
                    }
                }
            }
            
            // 是否显示空文档提示
            if (self.dataArray.count > 0) {
                self.noMessageView.alpha = 0;
                [self.reportTableView reloadData];
            }else{
                self.noMessageView.alpha = 1;
            }
            
            
        }
        
        if ([[NSString stringWithFormat:@"%@",dict[@"status"]] isEqualToString:@"1004"]) {
            //查询结果不存在
            self.noMessageView.alpha = 1;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败，错误信息 %@", error);
    }];
    
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


#pragma mark - 详情点击
- (IBAction)detailOnClick:(UIButton *)sender {
//    DayDetailVC * dayDetail = [[DayDetailVC alloc] initWithNibName:@"DayDetailVC" bundle:nil];
//    dayDetail.date = self.foodDate;
//    dayDetail.dateStr = self.date;
//    
//    [self.navigationController pushViewController:dayDetail animated:YES];
}

@end
