//
//  EnergyBalanceVC.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/10.
//
//

#import "EnergyBalanceVC.h"
#import "NeedAndTotalCell.h"
#import "CycleCell.h"
#import "BalanceCellTableViewCell.h"
#import "DietDefine.h"
#import "CycleCell.h"

static NSString* EB_REUSENEEDANDTOTALCELL = @"EnergyBalanceVC_REUSENEEDANDTOTALCELL";
static NSString* EB_CYCLE = @"EnergyBalanceVC_cyclecell";
static NSString* EB_BALANCE = @"EnergyBalanceVC_balance";

@interface EnergyBalanceVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *noMessageView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation EnergyBalanceVC


- (NSMutableArray<BalanceGroups *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noMessageView.alpha = 0;
    NSDateFormatter * fomate = [[NSDateFormatter alloc] init];
    [fomate setDateFormat:@"yyyy年MM月dd日"];
    self.dateLabel.text = [fomate stringFromDate:[NSDate date]];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.tableView registerClass:[NeedAndTotalCell class] forCellReuseIdentifier:EB_REUSENEEDANDTOTALCELL];
    [self.tableView registerClass:[CycleCell class] forCellReuseIdentifier:EB_CYCLE];
    
    [self.tableView registerClass:[BalanceCellTableViewCell class] forCellReuseIdentifier:EB_BALANCE];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf1faff);
    
    [self loadData];
}

- (void)loadData{
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
    
    [mDict setObject:self.module forKey:@"module"];
    if (userKey) {
        [mDict setObject:userKey forKey:@"userKey"];
    }
    
    [mDict setObject:AccessToken forKey:@"accessToken"];

    
    NSLog(@"平衡报告请求参数-%@", mDict);
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", DIET_COMMON, DIET_REPORT];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:urlStr parameters:mDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"平衡报告响应信息-%@", [dict yy_modelToJSONString]);
        
#pragma mark - 平衡报告解析
        BalanceModel * model = [BalanceModel yy_modelWithJSON:responseObject];
        
        // 设置标题
        if (model.data && model.data.header && model.data.header.length > 0)
        {
            self.dateLabel.text = model.data.header;
        }
        
        // 设置其他数据
        [self.dataArray removeAllObjects];
        if (model.status == 0) {
            [self.dataArray addObjectsFromArray:model.data.groups];
        }else{
            NSLog(@"平衡报告解析, 请求失败");
            //[XHToast showCenterWithText:@"请求失败" duration:2.0];
        }
        
        if (self.dataArray.count > 0) {
            self.noMessageView.alpha = 0;
            [self.tableView reloadData];
        }else{
            
            self.noMessageView.alpha = 1;
            //[XHToast showCenterWithText:@"您今天还没有填写过任何报告" duration:2];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败，错误信息 %@", error);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        NeedAndTotalCell * cell = [tableView dequeueReusableCellWithIdentifier:EB_REUSENEEDANDTOTALCELL];
        if (self.dataArray.count) {
            cell.model = self.dataArray[indexPath.row];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.row == 1){
        CycleCell * cell = [tableView dequeueReusableCellWithIdentifier:EB_CYCLE];
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        BalanceCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:EB_BALANCE];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count > 0) {
            cell.model = self.dataArray[indexPath.row];
        }
        
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 196;
    }else if(indexPath.row == 1){
        height = [CycleCell cellHeight];
    }else{
        height = 320;
    }
    return height;
}


@end
