//
//  CureReportViewController.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/14.
//
//

#import "CureReportViewController.h"

#import "ReportTextParaCell.h"
#import "DoubleListCell.h"
#import "YougeRemindCell.h"
#import "YGtrafficLightsCell.h"
#import "YGSportCell.h"
#import "NeedCareReportCellTableViewCell.h"
#import "YGSelfCureCell.h"
#import "YGBodayAgeCell.h"
#import "YGStripCell.h"
#import "YGCircleCell.h"
#import "T09Cell.h"
#import "T13Cell.h"
#import "YGT14Cell.h"
#import "T15Cell.h"
#import "T16Cell.h"
#import "T17Cell.h"
#import "T18Cell.h"
#import "T19Cell.h"
#import "T24Cell.h"
#import "YGT02Cell.h"
#import "YGReportT05TableViewCell.h"
#import "YGReportT06TableViewCell.h"
#import "YGT22Cell.h"
#import "YGLongitudinalListCell.h"  //T23
#import "YGPictureCell.h"           //T25
#import "YGT28Cell.h"
//#import "DayDetailVC.h"//T22详情点击跳转
#import "T16CustomSectionTableViewCell.h"
#import "YGT30Cell.h"
#import "YGT31Cell.h"
#import "YGT32Cell.h"
#import "YGT33Cell.h"
#import "YGT06Cell.h"
//#import "UnsuitableFeelController.h"
#import "ImageBrowserViewController.h"

@interface CureReportViewController ()<YGSportCellDelegate,YGT22CellDelegate,UITableViewDelegate,UITableViewDataSource,yGPictureCellDelegate>
{
    NSString* titleStr;//标题名称
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *reportTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *nodataMLabel;

@property (nonatomic,strong) UIView* pictureBackView;//点击显示图片背景

@property (nonatomic,strong) ReportControlModel *controlModel;

@end

@implementation CureReportViewController
#pragma mark - 懒加载
- (NSMutableArray *)itemsArray{
    if (_itemsArray == nil) {
        _itemsArray = [[NSMutableArray alloc] init];
    }
    return _itemsArray;
}
- (UIView *)pictureBackView{
    
    if (_pictureBackView == nil) {
        _pictureBackView = [[UIView alloc] init];
        _pictureBackView.frame = [UIScreen mainScreen].bounds;
        
    }
    
    return _pictureBackView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _noDataView.hidden = YES;
    
    if (!_isNotLoadReportData) {
        
        [self getReportData];
    }else{
        
        titleStr = _reportTitleStr;;
        self.dateLabel.text = _dateStr;
    }
    
    [self setupTableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 7, 20, 30);
    [btn addTarget:self action:@selector(theBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    
    if (_isHiddenDateLabel) {
        _dateLabel.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //将要加载页面时
    self.title = titleStr;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}

- (void)setReportModel:(ReportModel *)reportModel{
    
    _reportModel = reportModel;
    if (_reportModel.header && _reportModel.header !=  NULL) {
        self.dateLabel.text = [NSString stringWithFormat:@"    %@",_reportModel.header];
    }
    [self.itemsArray removeAllObjects];
    
    if (_reportModel.groups.count > 0) {
        
        _noDataView.hidden = YES;
        [self.itemsArray addObjectsFromArray:_reportModel.groups];
        [self.reportTableView reloadData];
    }else{
        
        _noDataView.hidden = NO;
        if (_noDataReminderStr.length > 0) {
            _nodataMLabel.text = _noDataReminderStr;
        }
    }
    
}

- (void)setupTableView{
    
    _reportTableView.delegate = self;
    _reportTableView.dataSource = self;
    //    _reportTableView.estimatedRowHeight = 100;
    //    _reportTableView.rowHeight = UITableViewAutomaticDimension;
    _reportTableView.allowsSelection = NO;
    
    if ([self.reportId isEqualToString:@"101"]) {
        //我的病历--基础信息报告跳转
        [_reportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }else if ([self.reportId isEqualToString:@"102"]){
        //我的病历 -- 门急诊列表
        [_reportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@64);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    
    //注册cell
    //T01红绿灯
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGtrafficLightsCell" bundle:nil] forCellReuseIdentifier:@"trafficLight"];
    
    //T02 雷达图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT02Cell" bundle:nil] forCellReuseIdentifier:@"yGT02Cell"];
    
    //T03 环状图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGCircleCell" bundle:nil] forCellReuseIdentifier:@"circleCell"];
    
    //T04 柱状图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGStripCell" bundle:nil] forCellReuseIdentifier:@"yGStripCell"];
    
    //T05 三餐占比图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGReportT05TableViewCell" bundle:nil] forCellReuseIdentifier:@"yGReportT05TableViewCell"];
    
    //T06 横向柱状图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT06Cell" bundle:nil] forCellReuseIdentifier:@"yGT06Cell"];
    
    //T07双列列表
    [_reportTableView registerNib:[UINib nibWithNibName:@"DoubleListCell" bundle:nil] forCellReuseIdentifier:@"doubleList"];
    //T08
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGSportCell" bundle:nil] forCellReuseIdentifier:@"sportCell"];
    //带其他按钮列表
    [_reportTableView registerNib:[UINib nibWithNibName:@"T09Cell" bundle:nil] forCellReuseIdentifier:@"T09Cell"];
    //T10佑格提示
    [_reportTableView registerNib:[UINib nibWithNibName:@"YougeRemindCell" bundle:nil] forCellReuseIdentifier:@"yougeRemind"];
    //T11文字段落
    [_reportTableView registerNib:[UINib nibWithNibName:@"ReportTextParaCell" bundle:nil] forCellReuseIdentifier:@"textPara"];
    //T12 需关注项
    [_reportTableView registerNib:[UINib nibWithNibName:@"NeedCareReportCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"needCare"];
    //T13 笑脸哭脸
    [_reportTableView registerNib:[UINib nibWithNibName:@"T13Cell" bundle:nil] forCellReuseIdentifier:@"T13Cell"];
    //T14 文字+数值
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT14Cell" bundle:nil] forCellReuseIdentifier:@"yGT14Cell"];
    
    //T15
    [_reportTableView registerNib:[UINib nibWithNibName:@"T15Cell" bundle:nil] forCellReuseIdentifier:@"T15Cell"];
    //T16
    [_reportTableView registerNib:[UINib nibWithNibName:@"T16Cell" bundle:nil] forCellReuseIdentifier:@"T16Cell"];
    //T17
    [_reportTableView registerNib:[UINib nibWithNibName:@"T17Cell" bundle:nil] forCellReuseIdentifier:@"T17Cell"];
    //T18
    [_reportTableView registerNib:[UINib nibWithNibName:@"T18Cell" bundle:nil] forCellReuseIdentifier:@"T18Cell"];
    //T19
    [_reportTableView registerNib:[UINib nibWithNibName:@"T19Cell" bundle:nil] forCellReuseIdentifier:@"T19Cell"];
    //T22
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT22Cell" bundle:nil] forCellReuseIdentifier:@"yGT22Cell"];
    //T23
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGLongitudinalListCell" bundle:nil] forCellReuseIdentifier:@"yGLongitudinalListCell"];
    
    //T24
    [_reportTableView registerNib:[UINib nibWithNibName:@"T24Cell" bundle:nil] forCellReuseIdentifier:@"T24Cell"];
    
    //T25
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGPictureCell" bundle:nil] forCellReuseIdentifier:@"pictureCell"];
    
    //T26
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGSelfCureCell" bundle:nil] forCellReuseIdentifier:@"selfCureCell"];
    
    //T27
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGBodayAgeCell" bundle:nil] forCellReuseIdentifier:@"bodayAgeCell"];
    
    //T28 生活日记说明
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT28Cell" bundle:nil] forCellReuseIdentifier:@"yGT28Cell"];
    
    //T29
    [_reportTableView registerNib:[UINib nibWithNibName:@"T16CustomSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"T16CustomSectionTableViewCell"];
    
    //T30 蓝底标题
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT30Cell" bundle:nil] forCellReuseIdentifier:@"yGT30Cell"];
    
    //T31 检查项
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT31Cell" bundle:nil] forCellReuseIdentifier:@"yGT31Cell"];
    
    //T32 饼图
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT32Cell" bundle:nil] forCellReuseIdentifier:@"yGT32Cell"];
    
    //T33 标签
    [_reportTableView registerNib:[UINib nibWithNibName:@"YGT33Cell" bundle:nil] forCellReuseIdentifier:@"yGT33Cell"];
    
}

- (void)theBackBtnClicked:(UIButton *) backBtn{
    
    if (_isPopRootVC) {
        
        //健康报告-历史报告
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (_isHealthHistoryReport) {
        
        //健康报告-历史报告
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
    }else if ([_module isEqualToString:@"LiveDiary_BodyFeeling"] || [_module isEqualToString:@"Evaluation_Sport"]) {
        if([self.lifeDiaryDetailStr isEqualToString:@"100"]){
            //雷达图跳转
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //体感报告返回体感首页
            
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:2];
            if ([self.lifeDiaryDetailStr isEqualToString:@"101"]) {
                //首页进入体感 -- 问卷 --报告
                vc = [self.navigationController.viewControllers objectAtIndex:1];
            }
            if ([_module isEqualToString:@"Evaluation_Sport"]) {
                //问卷复制的报告
                vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4];
            }
            
            if ([vc canPerformAction:@selector(reloadTargetQNView) withSender:nil]) {
                [vc performSelector:@selector(reloadTargetQNView)];
            }
            
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    }else if ([_module isEqualToString:@"LiveDiary_BodyIndex"] ) {
        
        //指标报告返回体感首页、运动评测
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else if (_isDetailReport) {
        
        //指标报告返回体感首页
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if ([self.lifeDiaryDetailStr isEqualToString:@"100"]) {
            //从生活日记汇总报告雷达图中点击进入，则返回雷达图页面
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //返回生活日记首页
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
        }
        
    }
}

#pragma mark --  加载问卷报告
- (void)getReportData{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (self.cycle) {
        
        [param setValue:self.cycle forKey:@"cycle"];
    }else{
        
        [param setValue:@"daily" forKey:@"cycle"];
    }
    
    [param setValue:@(self.date) forKey:@"date"];
    if (self.detailKey) {
        //T08报告的detailKey
        [param setValue:self.detailKey forKey:@"detailKey"];
    }
    if (self.searchKey) {
        //体感首页搜索
        [param setValue:_searchKey forKey:@"searchKey"];
    }
    
    [param setValue:self.module forKey:@"module"];
    [param setValue:self.userIdStr forKey:@"userId"];
    [param setValue:AccessToken forKey:@"accessToken"];
    
    
    NSString* url = [NSString stringWithFormat:@"%@/report/getPatientReport",UGAPI_HOST];
    
    [TLAsiNetworkHandler requestWithUrl:url params:param showHUD:YES httpMedthod:TLAsiNetWorkPOST successBlock:^(id responseObj) {
        if (responseObj) {
            
            if ([responseObj[@"status"] isEqual:@0]) {
                _reportModel = [ReportModel yy_modelWithDictionary:responseObj[@"data"]];
                self.title = _reportModel.title;
                titleStr = _reportModel.title;
                //获取月日
                if (_reportModel.header && _reportModel.header !=  NULL) {
                    self.dateLabel.text = [NSString stringWithFormat:@"    %@",_reportModel.header];
                }
                if (_reportModel.groups.count > 0) {
                    
                    _noDataView.hidden = YES;
                    [self.itemsArray addObjectsFromArray:_reportModel.groups];
                    [self.reportTableView reloadData];
                }else{
                    
                    _noDataView.hidden = NO;
                    if (_noDataReminderStr.length > 0) {
                        _nodataMLabel.text = _noDataReminderStr;
                    }
                }
                
            }else if(responseObj[@"message"]){
                _noDataView.hidden = NO;
                if (_noDataReminderStr.length > 0) {
                    _nodataMLabel.text = _noDataReminderStr;
                }
                //NSLog(@"%@",returnData[@"message"]);
                //[XHToast showBottomWithText:returnData[@"message"]];
                //[self.navigationController popViewControllerAnimated:YES];
            }else{
                _noDataView.hidden = NO;
                if (_noDataReminderStr.length > 0) {
                    _nodataMLabel.text = _noDataReminderStr;
                }
            }
            
        }

    } failBlock:^(NSError *error) {
        [XHToast showBottomWithText:@"加载失败"];
    }];
     
    
}


#pragma mark - 图文混排:富文本显示文字和图片
- (NSAttributedString *) mixImage:(UIImage *) image text:(NSString *) text{
    //将图片转换成文本附件
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    
    //将文本附件转换成富文本
    NSAttributedString *imageAttri = [NSAttributedString attributedStringWithAttachment:imageMent];
    
    //将文字转换成富文本
    NSAttributedString *textAttri = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",text] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    //将文字富文本和图片富文本拼接起来
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    //    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:@"" attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]init];
    [attriStr appendAttributedString:imageAttri];
    [attriStr appendAttributedString:textAttri];
    
    //返回富文本
    return attriStr;
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.itemsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ReportGroupModel *groupModel = self.itemsArray[section];
    if (groupModel.controll.collapse) {
        //折叠
        return 0;
    }else{
        //展开
        return groupModel.items.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ReportGroupModel *groupModel = self.itemsArray[section];
    if (groupModel.controll) {
        
        return 40;
    }
    return 0.001f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ReportGroupModel *groupModel = self.itemsArray[section];
    UIView* headerView = [[UIView alloc] init];
    //    if (groupModel.background == 1) {
    
    if (groupModel.controll) {
        
        headerView.backgroundColor = [UIColor whiteColor];
        //    }else{
        //        headerView.backgroundColor = [UIColor whiteColor];
        //    }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"title_green"];
        [headerView addSubview:imageView];
        
        UILabel* namesLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, kScreenWidth - 60, 40)];
        namesLab.text = [NSString stringWithFormat:@"%@",groupModel.controll.text];
        namesLab.textColor = Style_Color_Content_Black;
        [headerView addSubview:namesLab];
        
        WFHelperButton *btn = [WFHelperButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 5, kScreenWidth, 30);
        btn.groupModel = groupModel;
        //是否允许折叠展开
        if (groupModel.controll.fold) {
            
            btn.userInteractionEnabled = YES;
        }else{
            btn.userInteractionEnabled = NO;
        }
        if (groupModel.controll.collapse) {
            //折叠
            [btn setImage:[UIImage imageNamed:@"right_public"] forState:UIControlStateNormal];
        }else{
            //展开
            [btn setImage:[UIImage imageNamed:@"down_public"] forState:UIControlStateNormal];
        }
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth - 30, 0, 0)];
        [btn addTarget:self action:@selector(collapseBtnClciked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        
        
        
    }
    
    
    
    
#warning 报告重构至此
    //    ReportItemModel *itemModel = self.itemsArray[section];
    //    ReportItemDataModel *data = itemModel.data;
    //    NSMutableArray* nameArr = [NSMutableArray array];
    //    [nameArr addObjectsFromArray:data.names];
    //
    //    if ([itemModel.type isEqualToString:@"T08"]) {
    //        //运动报告页面的选项卡
    //
    //        headerView.backgroundColor = UIColorFromRGB(0xd8f5e4);
    //        for (int i = 0; i < nameArr.count; i++) {
    //            UILabel* namesLab = [[UILabel alloc] initWithFrame:CGRectMake(0+(kScreenWidth/nameArr.count)*i, 0, kScreenWidth/nameArr.count, 40)];
    //            namesLab.text = nameArr[i];
    //            namesLab.textAlignment = NSTextAlignmentCenter;
    //            namesLab.textColor = Style_Color_Content_TextTitleColor;
    //            [headerView addSubview:namesLab];
    //        }
    //
    //
    //
    //    }else if ([itemModel.type isEqualToString:@"T03"] || [itemModel.type isEqualToString:@"T04"]) {
    //        //T03、T04不显示header
    //
    //    }else{
    //
    //        ReportControlModel *control =  nil;
    //        if ((itemModel.caption && itemModel.caption.text) || (control && control.text)) {
    //            UILabel* namesLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    //            namesLab.backgroundColor = RGBCOLOR(207, 245, 222);;
    //            if (itemModel.caption && itemModel.caption.text) {
    //                namesLab.text = itemModel.caption.text;
    //            }else{
    //                namesLab.text = control.text;
    //            }
    //            namesLab.textAlignment = NSTextAlignmentCenter;
    //            namesLab.textColor = [UIColor darkGrayColor];
    //            [headerView addSubview:namesLab];
    //
    //            if (itemModel.data.detail && ([itemModel.type isEqualToString:@"T15"] || [itemModel.type isEqualToString:@"T16"] || [itemModel.type isEqualToString:@"T18"]|| [itemModel.type isEqualToString:@"T19"] || [itemModel.type isEqualToString:@"T24"])) {
    //                //设置详情按钮
    //                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    //                btn.frame = CGRectMake(kScreenWidth - 60, 5, 50, 30);
    //                [btn setTitle:@"详情" forState:UIControlStateNormal];
    //                btn.layer.masksToBounds = YES;
    //                btn.layer.borderWidth = 1;
    //                btn.layer.cornerRadius = 5;
    //                [btn addTarget:self action:@selector(detailButnClick:) forControlEvents:UIControlEventTouchUpInside];
    //                btn.tag = section + 1000;
    //                [btn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    //                btn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
    //                [headerView addSubview:btn];
    //            }
    //        }
    //    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReportGroupModel *groupModel = self.itemsArray[indexPath.section];
    ReportItemModel *itemModel = groupModel.items[indexPath.row];
    ReportItemDataModel *itemData = itemModel.data;
    
    
    if ([itemModel.type isEqualToString:@"T01"]) {
        //红绿灯
        YGtrafficLightsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trafficLight"];
        
        cell.dataModel = itemData;
        
        return cell;
        
    }else if ([itemModel.type isEqualToString:@"T02"]) {
        //T02  雷达图
        YGT02Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT02Cell"];
        
        cell.dataModel = itemData;
        
        NSString* titleName = self.title;
        
        if ([titleName containsString:@"中医体质评测结果"]) {
            NSLog(@"titleName 包含 中医体质评测结果");
            //中医体质评测的雷达图不显示分数
            cell.showMarkLabel = NO;
        } else {
            NSLog(@"titleName 不包含 中医体质评测结果");
            cell.showMarkLabel = YES;
        }
        return cell;
        
        
    }else if ([itemModel.type isEqualToString:@"T03"]) {
        //T03  环状图
        
        YGCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"circleCell"];
        ReportCaptionModel *captionModel = itemModel.caption;
        cell.titleStr = captionModel.text;
        
        cell.dataModel = itemData;
        
        return cell;
        
        
    }else if ([itemModel.type isEqualToString:@"T04"]) {
        //T04  柱状图
        YGStripCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGStripCell"];
        ReportCaptionModel *captionModel = itemModel.caption;
        cell.titleStr = captionModel.text;
        cell.left = captionModel.left;
        cell.dataModel = itemData;
        
        return cell;
        
        
    }else if ([itemModel.type isEqualToString:@"T05"]) {
        //T05 三餐占比图
        
        NSArray *datas = itemData.list;
        
        YGReportT05TableViewCell *realCell = [self.reportTableView dequeueReusableCellWithIdentifier:@"yGReportT05TableViewCell"];
        if (datas.count == 3) {
            if ([datas[2] isKindOfClass:[NSDictionary class]]) {
                //晚餐
                NSDictionary* dict = datas[2];
                realCell.namex = dict[@"name"];
                realCell.standardx = [dict[@"std"] floatValue];
                realCell.x = [dict[@"value"] floatValue];
            }
            if ([datas[1] isKindOfClass:[NSDictionary class]]) {
                //晚餐
                NSDictionary* dict = datas[1];
                realCell.namey = dict[@"name"];
                realCell.standardy = [dict[@"std"] floatValue];
                realCell.y = [dict[@"value"] floatValue];
            }
            
            if ([datas[0] isKindOfClass:[NSDictionary class]]) {
                //晚餐
                NSDictionary* dict = datas[0];
                realCell.namez = dict[@"name"];
                realCell.standardz = [dict[@"std"] floatValue];
                realCell.z = [dict[@"value"] floatValue];
            }
            
        }
        
        return realCell;
        
        
    }else if ([itemModel.type isEqualToString:@"T06"]) {
        
        //T06 横向柱状图
        
        YGT06Cell *realCell = [self.reportTableView dequeueReusableCellWithIdentifier:@"yGT06Cell"];
        
        realCell.itemModel = itemModel;
        return realCell;
        
        
    }else if ([itemModel.type isEqualToString:@"T07"]) {
        
#warning 重构
        //T07双列列表
        DoubleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doubleList"];
        
        cell.itemModel = itemModel;
        //        cell.dict = itemData.list[indexPath.row];
        //        if (indexPath.row != itemData.list.count-1) {
        //
        //            UILabel* lab = [[UILabel alloc] init];
        //            lab.backgroundColor = UIColorFromRGB(0xefefef);
        //            [cell addSubview:lab];
        //            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.left.equalTo(cell.mas_left);
        //                make.right.equalTo(cell.mas_right);
        //                make.bottom.equalTo(cell.mas_bottom);
        //                make.height.equalTo(@1);
        //            }];
        //
        //        }
        
        
        return cell;
        
    }else if ([itemModel.type isEqualToString:@"T08"]) {
        
        //T08含有详情按钮
        //解决上滑重影问题，取出不同的cell
        YGSportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sportCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.itemModel = itemModel;
        //cell.dataModel = itemData;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T09"]) {
        //佑格提示;
        T09Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T09Cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.dataModel = itemData;
        cell.itemModel = itemModel;
        if (_presentVC) {
            cell.vc = _presentVC;
        }else{
            __weak typeof(self) weakSelf = self;
            cell.vc = weakSelf;
        }
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        return cell;
    }else if ([itemModel.type isEqualToString:@"T10"]) {
        //佑格提示;
        YougeRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yougeRemind"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        return cell;
    }else if ([itemModel.type isEqualToString:@"T11"]) {
#warning 重构
        //T11文字段落;
        ReportTextParaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textPara"];
        
        cell.itemModel = itemModel;
        //        if (indexPath.row != 0) {
        //            cell.picImageView.hidden = YES;
        //        }
        //cell.textStr = itemData.list[indexPath.row];
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T12"]){
        //T12需关注项
        NeedCareReportCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"needCare"];
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T13"]){
        //T13需关注项
        T13Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T13Cell"];
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T14"]){
        //T14 文字+数值
        YGT14Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT14Cell"];
        cell.dataModel = itemData;
        return cell;
        
    }else if ([itemModel.type isEqualToString:@"T15"]) {
        
        //单线折线图
        T15Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T15Cell"];
        if ([_cycle isEqualToString:@"monthly"]) {
            cell.stepCount = 5;
        }
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        //cell.dataModel = itemData;
        cell.path = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T16"]) {
        
        //单线带区间折线图
        T16Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T16Cell"];
        if ([_cycle isEqualToString:@"monthly"]) {
            cell.stepCount = 5;
        }
        cell.itemModel = itemModel;
        cell.path = indexPath;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        //[cell configUI:indexPath Lines:10 StepCount:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.dataModel = itemData;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T17"]) {
        
        //详细列表
        T17Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T17Cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.itemModel = itemModel;
        return cell;
    }else if ([itemModel.type isEqualToString:@"T18"]) {
        
        //柱状图
        T18Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T18Cell"];
        if ([_cycle isEqualToString:@"monthly"]) {
            cell.colNum = 5;
        }else{
            cell.colNum = 1;
        }
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T19"]) {
        
        //单线带区间折线图
        T19Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T19Cell"];
        if ([_cycle isEqualToString:@"monthly"]) {
            cell.stepCount = 5;
        }
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        cell.path = indexPath;
        //[cell configUI:indexPath Lines:10 StepCount:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.dataModel = itemData;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T22"]) {
        //T22 饮食佑格分+摄入
        YGT22Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT22Cell"];
        cell.delegate = self;
        cell.IsSimpleNum = self.reportModel.IsSimple;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = itemData;
        
        return cell;
    }else if ([itemModel.type isEqualToString:@"T23"]) {
        //纵向表格
        YGLongitudinalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGLongitudinalListCell"];
        
        cell.itemModel = itemModel;
        
        return cell;
        
    }else if ([itemModel.type isEqualToString:@"T24"]) {
        
        //T24
        T15Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"T15Cell"];
        if ([_cycle isEqualToString:@"monthly"]) {
            cell.stepCount = 5;
        }
        cell.itemModel = itemModel;
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        cell.path = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if ([itemModel.type isEqualToString:@"T25"]){
        //图片列表
        YGPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell"];
        
        NSMutableArray* arr = [NSMutableArray array];
        [arr addObjectsFromArray:itemData.list];
        cell.delegate = self;
        cell.mutArr = arr;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T26"]){
        //T26 自愈评测结果
        NSLog(@"%@",itemData);
        NSLog(@"%@",itemModel);
        NSLog(@"123");
        
        YGSelfCureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selfCureCell"];
        
        cell.dataModel = itemData;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T27"]){
        //T27 身体年龄评测结果
        NSLog(@"%@",itemData);
        NSLog(@"%@",itemModel);
        NSLog(@"123");
        
        YGBodayAgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodayAgeCell"];
        
        cell.dataModel = itemData;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T28"]){
        //T28 生活日记说明
        NSLog(@"%@",itemData);
        NSLog(@"%@",itemModel);
        NSLog(@"123");
        
        YGT28Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT28Cell"];
        
        cell.dataModel = itemData;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T29"]){
        //T29
        
        T16CustomSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"T16CustomSectionTableViewCell"];
        if ([_cycle isEqualToString:@"weekly"]) {
            cell.nums = 7;
        }
        cell.detailBlock = ^(ReportItemModel *itemDetailModel){
            [self detailButnClickWithDetailReportModel:itemDetailModel];
        };
        cell.itemModel = itemModel;
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T30"]){
        //T30 蓝底标题
        
        YGT30Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT30Cell"];
        
        cell.dataModel = itemData;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T31"]){
        //T31 体检
        
        YGT31Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT31Cell"];
        
        cell.itemModel = itemModel;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T32"]){
        //T32 饼图
        
        YGT32Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT32Cell"];
        
        cell.itemModel = itemModel;
        
        return cell;
        
    }else if([itemModel.type isEqualToString:@"T33"]){
        //T33 标签
        
        YGT33Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"yGT33Cell"];
        
        cell.itemModel = itemModel;
        
        return cell;
        
    }
    ReportTextParaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textPara"];
    cell.textStr = @"呵呵哒的空间按户口好阿卡的adadadad adawfa da a a a a fa发  艾尔发放发额额 分是粉色色是额额而是 话 按快点哈按客户安科技啊大大大啊大大大我的娃";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    //    ReportItemModel *itemModel = self.itemsArray[section];
    //    if ([itemModel.type isEqualToString:@"T11"]) {
    //        return 0;
    //
    //    }else{
    return 0.001;
    //    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    //view.backgroundColor = RGBCOLOR(230, 230, 230);
    return view;
}

#pragma mark --  T08_详情按钮列表点击事件(#YGSportCellDelegate#)
- (void)yGSportCellDetailBtnClickWithButton:(WFHelperButton *)sender
{
    NSString* detailKey = sender.detail;
    
    //运动报告跳转详情
    UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
    CureReportViewController *cureReportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
    if (detailKey.length > 8) {
        //营养品周报告，detailKey中含有日期
        cureReportVC.date = [[detailKey substringToIndex:8] integerValue];
    }else{
        //运动、体感的报告直接传日期
        cureReportVC.date = self.date;
        
    }
    
    cureReportVC.module = self.module;
    cureReportVC.cycle = @"detail";
    cureReportVC.detailKey = detailKey;
    cureReportVC.isNotLoadReportData = NO;
    cureReportVC.lifeDiaryDetailStr = @"100";
    [self.navigationController pushViewController:cureReportVC animated:YES];
    
}
#pragma mark --  T22_详情按钮列表点击事件(#YGT22CellDelegate#)
- (void)yGT22CellDetailBtnClickWithButton:(UIButton *)button
{
    NSLog(@"T22报告详情按钮点击");
//    DayDetailVC * dayDetail = [[DayDetailVC alloc] initWithNibName:@"DayDetailVC" bundle:nil];
//    dayDetail.dateStr = self.date;
//    [self.navigationController pushViewController:dayDetail animated:YES];
    
}
//标题头上的详情按钮点击事件
- (void)detailButnClickWithDetailReportModel:(ReportItemModel *)itemDetailModel{
    
    UIStoryboard *selfCureSB = [UIStoryboard storyboardWithName:@"SelfCure" bundle:nil];
    CureReportViewController *reportVC = [selfCureSB instantiateViewControllerWithIdentifier:@"CureReportViewController"];
    reportVC.isNotLoadReportData = YES;
    reportVC.isDetailReport = YES;
    reportVC.reportTitleStr = titleStr;
    reportVC.dateStr = _dateLabel.text;
    //将单个报告转成组报告
    ReportGroupModel *group = [[ReportGroupModel alloc] init];
    group.items = @[itemDetailModel];
    [reportVC.itemsArray addObject:group];
    if (_presentVC) {
        [_presentVC.navigationController pushViewController:reportVC animated:YES];
    }else{
        [self.navigationController pushViewController:reportVC animated:YES];
    }
    
}
#pragma mark -- T25_图片点击代理方法<yGPictureCellDelegate>
- (void)yGPictureCellDetailBtnClickWithUrl:(NSString *)urlStr image:(UIImage *)image
{
    
    UIViewController *vc = _presentVC?_presentVC:self;
    [ImageBrowserViewController show:vc type:PhotoBroswerVCTypeModal index:0 picUrl:urlStr imagesBlock:^NSArray *{
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:image];
        return arr;
    }];
//    NSLog(@"pictureCellUrl:%@",urlStr);
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
//    
//    _pictureBackView = [[UIView alloc] init];
//    _pictureBackView.frame = [UIScreen mainScreen].bounds;
//    _pictureBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    //给视图添加点击方法
//    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackView)];
//    recognizer.numberOfTapsRequired=1;
//    [_pictureBackView addGestureRecognizer:recognizer];
//    [[UIApplication sharedApplication].keyWindow addSubview:_pictureBackView];
//    
//    
//    UIImageView* pictureView = [[UIImageView alloc] init];
//    pictureView.contentMode = UIViewContentModeScaleAspectFit;
//    pictureView.image = image;
//    [_pictureBackView addSubview:pictureView];
//    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_pictureBackView.mas_centerX);
//        make.centerY.equalTo(_pictureBackView.mas_centerY);
//        make.width.equalTo(_pictureBackView.mas_width).multipliedBy(0.8);
//        
//    }];
    
    
}

#pragma mark - 组报告折叠展开
- (void)collapseBtnClciked:(WFHelperButton *)btn{
    
    btn.groupModel.controll.collapse = !btn.groupModel.controll.collapse;
    [self.reportTableView reloadData];
}

#pragma mark -- 点击图片显示背景方法,移除背景视图
- (void)removeBackView
{
    //移除_pictureBackView
    [_pictureBackView removeFromSuperview];
}
@end
