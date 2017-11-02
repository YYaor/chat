//
//  YGT06Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 17/2/7.
//
//
///////////////////T06 横向柱状图//////////////////////////

#import "YGT06Cell.h"
#import "YGReportT06TableViewCell.h"
#import "DietReportHeadCell.h"     //T06膳食金字塔标题

#define cellHeight 120.0
@interface YGT06Cell ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* lineTable;
    
}

@property (weak, nonatomic) IBOutlet UILabel *legentLab;//控制高度Label
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labHeight;//高度

@end

@implementation YGT06Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

//setter方法
- (void)setItemModel:(ReportItemModel *)itemModel
{
    _itemModel = itemModel;
    NSLog(@"%@",itemModel);
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    CGFloat tableHeight = itemModel.data.list.count * cellHeight + 90;
    
    self.labHeight.constant = tableHeight;
    
    lineTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, tableHeight) style:UITableViewStylePlain];
    lineTable.delegate = self;
    lineTable.dataSource = self;
    lineTable.allowsSelection = NO;
    lineTable.scrollEnabled = NO;
    [self addSubview:lineTable];
    
    //膳食金字塔
    [lineTable registerNib:[UINib nibWithNibName:@"DietReportHeadCell" bundle:nil] forCellReuseIdentifier:@"dietReportHeadCell"];
    //T06 横向柱状图
    [lineTable registerNib:[UINib nibWithNibName:@"YGReportT06TableViewCell" bundle:nil] forCellReuseIdentifier:@"yGReportT06TableViewCell"];
    
    [lineTable reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemModel.data.list.count;
}
//自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xF1FAFF);
    //标题
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.text = self.itemModel.caption.text;
    titleLab.textColor = UIColorFromRGB(0x5593E8);
    titleLab.font = [UIFont systemFontOfSize:24];
    [headerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@15);
    }];
    
    UILabel* standardLab = [[UILabel alloc] init];
    standardLab.text = @"您的标准区间";
    standardLab.font = [UIFont systemFontOfSize:13.0f];
    standardLab.textColor = Style_Color_Content_Black;
    [headerView addSubview:standardLab];
    [standardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).offset(-13);
        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
    }];
    
    UIView* blueView = [[UIView alloc] init];
    blueView.backgroundColor = UIColorFromRGB(0x5593E8);
    [headerView addSubview:blueView];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(standardLab.mas_left).offset(-5);
        make.centerY.equalTo(standardLab.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@13);
    }];
    
    UILabel* yourValueLab = [[UILabel alloc] init];
    yourValueLab.text = @"您的值";
    yourValueLab.font = [UIFont systemFontOfSize:13.0f];
    yourValueLab.textColor = Style_Color_Content_Black;
    [headerView addSubview:yourValueLab];
    [yourValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(blueView.mas_left).offset(-10);
        make.centerY.equalTo(blueView.mas_centerY);
        make.width.equalTo(@42);
        make.height.equalTo(@13);
    }];
    
    UIImageView* sanjiaoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sanjiao"]];
    sanjiaoImgView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:sanjiaoImgView];
    [sanjiaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yourValueLab.mas_left).offset(-5);
        make.centerY.equalTo(blueView.mas_centerY);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    
    
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGReportT06TableViewCell *realCell = [lineTable dequeueReusableCellWithIdentifier:@"yGReportT06TableViewCell"];
    NSArray *datas = self.itemModel.data.list;
    if ([datas[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = datas[indexPath.row];
        realCell.name = dict[@"name"];
        realCell.unit = dict[@"unit"];
        realCell.minValue = [dict[@"min"] integerValue];
        realCell.maxValue = [dict[@"max"] integerValue];
        realCell.yourMaxValue = [dict[@"std_max"] integerValue];
        realCell.yourMinValue = [dict[@"std_min"] integerValue];
        realCell.yourValue = [dict[@"value"] integerValue];
        
    }
    
    return realCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
