//
//  YGSportCell.m
//  YouGeHealth
//
//  Created by 王全江 on 16/11/2.
//
//

#import "YGSportCell.h"

#define cellHeight 50

@interface YGSportCell ()

@property (weak, nonatomic) IBOutlet UIView *headerView;//T08头部标识图

@property (weak, nonatomic) IBOutlet UIView *reportView;//报告内容

@property (weak, nonatomic) IBOutlet UILabel *legentLab;//底部约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportHeiCont;//报告内容高度约束




@end


@implementation YGSportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"00000000000000000000");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    self.dataModel = itemModel.data;
}

- (void)setDataModel:(ReportItemDataModel *)dataModel
{
//    self.backgroundColor = [UIColor redColor];
    
    _dataModel = dataModel;
    
    self.mutArr = dataModel.list;
   
    self.reportHeiCont.constant = dataModel.list.count * cellHeight;
    
    for (UIView *v in _headerView.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in _reportView.subviews) {
        [v removeFromSuperview];
    }
    
    //上部每一块儿名称
    for (int nameCont = 0; nameCont < dataModel.names.count; nameCont++) {
        UILabel* nameLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth/dataModel.names.count)*nameCont, 0, kScreenWidth/dataModel.names.count, 40)];
        nameLab.text = dataModel.names[nameCont];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.textColor = Style_Color_Content_Black;
        [self.headerView addSubview:nameLab];
    }
    
    NSMutableArray* dataArr = [NSMutableArray array];
    
    //下面cell
    for (int i = 0 ; i < self.mutArr.count; i++) {
        //先创建View
        UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight * i, kScreenWidth, 50)];
        [self.reportView addSubview:cellView];
        
        //创建分割线
        UILabel* lineLab = [[UILabel alloc] init];
        lineLab.backgroundColor = UIColorFromRGB(0xEFEFEF);
        [cellView addSubview:lineLab];
        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellView.mas_left);
            make.right.equalTo(cellView.mas_right);
            make.bottom.equalTo(cellView.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        
        //创建项目
        if ([self.mutArr[i] isKindOfClass:[NSArray class]]) {
            [dataArr removeAllObjects];
            [dataArr addObjectsFromArray:self.mutArr[i]];
            
            //每一个数据
            for (int j = 0; j < dataArr.count; j ++) {
                //创建每一行的View
                UIView* projView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/dataArr.count)*j, 0, kScreenWidth/dataArr.count, cellHeight)];
                
                [cellView addSubview:projView];
//                if (j == 0) {
//                    
//                    projView.backgroundColor = [UIColor redColor];
//                }else if (j == 1){
//                    
//                    projView.backgroundColor = [UIColor blueColor];
//                }else if (j == 2){
//                    
//                    projView.backgroundColor = [UIColor yellowColor];
//                }else if (j == 3){
//                    
//                    projView.backgroundColor = [UIColor lightGrayColor];
//                }
                
                if (j == dataArr.count - 1) {
                    //最后一个显示为按钮
                    
                    WFHelperButton* detailButn = [[WFHelperButton alloc] init];
                    [detailButn setTitle:@"详情" forState:UIControlStateNormal];
                    detailButn.tag = 1993 + i;
                    [detailButn addTarget:self action:@selector(detailButnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [detailButn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
                    detailButn.layer.borderWidth = 0.5;
                    detailButn.layer.cornerRadius = 6.0f;
                    detailButn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
                    [projView addSubview:detailButn];
                    [detailButn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(projView.mas_centerX);
                        make.centerY.equalTo(projView.mas_centerY);
                        make.width.equalTo(@50);
                        make.height.equalTo(@30);
                    }];
                    
                }else{
                    //放置名称
                    UILabel* nameLab = [[UILabel alloc] init];
                    nameLab.text = dataArr[j];
                    nameLab.font = [UIFont systemFontOfSize:18];
                    nameLab.textAlignment = NSTextAlignmentCenter;
                    nameLab.textColor = Style_Color_Content_Black;
                    [projView addSubview:nameLab];
                    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(projView.mas_centerX);
                        make.centerY.equalTo(projView.mas_centerY);
                        
                    }];
                    
                }
                
                
                
                
                
            }
            
            
        }

        
        
        
        
    }
    
    
}


//- (void)setMutArr:(NSArray *)mutArr{
//    
//    _mutArr = mutArr;
//    self.sportTimeLab.hidden = YES;
//    self.sportNameLab.hidden = YES;
//    self.detailBtn.hidden = YES;
//    
//    
//    //控制cell的高度
//    UILabel* heightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight* self.mutArr.count + 40)];
//    [self.contentView addSubview:heightLab];
//    
//    
//    //header
//    UIView* headerView = [[UIView alloc] init];
//    headerView.backgroundColor = UIColorFromRGB(0xdaf5e4);
//    [heightLab addSubview:headerView];
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
//        make.height.equalTo(@40);
//    }];
//    
//    
//    for (int i = 0 ; i < self.mutArr.count; i++) {
//        //先创建View
//        UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight * i, self.contentView.frame.size.width, 50)];
//        [self.contentView addSubview:cellView];
//        
//        //创建分割线
//        UILabel* lineLab = [[UILabel alloc] init];
//        lineLab.backgroundColor = UIColorFromRGB(0xEFEFEF);
//        [cellView addSubview:lineLab];
//        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cellView.mas_left);
//            make.right.equalTo(cellView.mas_right);
//            make.bottom.equalTo(cellView.mas_bottom);
//            make.height.equalTo(@0.5);
//        }];
//        
//        //创建项目
//        for (NSArray* dataArr in mutArr)
//        {
//            //每一个数据
//            for (int j = 0; j < dataArr.count; j ++) {
//                //创建每一行的View
//                UIView* projView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/dataArr.count)*i, 0, kScreenWidth/dataArr.count, cellHeight)];
//                
//                if (i == dataArr.count-1) {
//                    //最后一个显示为按钮
//                    
//                    UIButton* detailButn = [[UIButton alloc] init];
//                    [detailButn setTitle:@"详情" forState:UIControlStateNormal];
//                    detailButn.tag = 1993 + i;
//                    [detailButn addTarget:self action:@selector(detailButnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [detailButn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
//                    detailButn.layer.borderWidth = 0.5;
//                    detailButn.layer.cornerRadius = 6.0f;
//                    detailButn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
//                    [projView addSubview:detailButn];
//                    [detailButn mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.equalTo(projView.mas_centerX);
//                        make.centerY.equalTo(projView.mas_centerY);
//                        make.width.equalTo(@50);
//                        make.height.equalTo(@30);
//                    }];
//                    
//                }else{
//                    //放置名称
//                    UILabel* nameLab = [[UILabel alloc] init];
//                    nameLab.text = dataArr[j];
//                    nameLab.textAlignment = NSTextAlignmentCenter;
//                    nameLab.textColor = Style_Color_Content_TextTitleColor;
//                    [projView addSubview:nameLab];
//                    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.equalTo(projView.mas_centerX);
//                        make.centerY.equalTo(projView.mas_centerY);
//                        
//                    }];
//                    
//                }
//                
//                
//                
//                
//                
//            }
//            
//            
//            
//        }
//        
//        
//    }
//    
//    
//    
////    for (int i = 0; i <self.mutArr.count; i++) {
////        
////        if (i == self.mutArr.count-1) {
////            //最后一个显示为按钮
////            
////            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(i * kScreenWidth/self.mutArr.count, 0, kScreenWidth/self.mutArr.count, self.frame.size.height)];
////            [self.contentView addSubview:view];
////            
////            UIButton* detailButn = [[UIButton alloc] init];
////            [detailButn setTitle:@"详情" forState:UIControlStateNormal];
////            detailButn.tag = 1993 + i;
////            [detailButn addTarget:self action:@selector(detailButnClick:) forControlEvents:UIControlEventTouchUpInside];
////            [detailButn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
////            detailButn.layer.borderWidth = 0.5;
////            detailButn.layer.cornerRadius = 6.0f;
////            detailButn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
////            [view addSubview:detailButn];
////            [detailButn mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.centerX.equalTo(view.mas_centerX);
////                make.centerY.equalTo(view.mas_centerY);
////                make.width.equalTo(@50);
////                make.height.equalTo(@30);
////            }];
////            
////        }else{
////            //创建Label
////            UILabel* listLab = [[UILabel alloc] initWithFrame:CGRectMake(0+(kScreenWidth/self.mutArr.count)*i, 0, kScreenWidth/self.mutArr.count, self.frame.size.height)];
////            listLab.textAlignment = NSTextAlignmentCenter;
////            listLab.text = self.mutArr[i];
////            listLab.textColor = Style_Color_Content_TextTitleColor;
////            [self.contentView addSubview:listLab];
////        }
////        
////    }
//    
//    
//}
- (void)detailButnClick:(WFHelperButton *)sender
{
    NSInteger detailKeyTag = sender.tag - 1993;
    
    if ([self.mutArr[detailKeyTag] isKindOfClass:[NSArray class]]){
        NSArray *detailKeyArr = self.mutArr[detailKeyTag];
        sender.detail = [NSString stringWithFormat:@"%@",[detailKeyArr lastObject]];
        [_delegate yGSportCellDetailBtnClickWithButton:sender];
    }
    
}

@end
