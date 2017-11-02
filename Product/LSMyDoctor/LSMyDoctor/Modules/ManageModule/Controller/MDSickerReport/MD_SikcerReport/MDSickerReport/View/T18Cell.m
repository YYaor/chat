//
//  T18Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import "T18Cell.h"
#import "JHChartHeader.h"

@interface T18Cell ()

@property (weak, nonatomic) IBOutlet UIView *t18View;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation T18Cell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    
    [_detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _detailBtn.layer.masksToBounds = YES;
    _detailBtn.layer.borderWidth = 1;
    _detailBtn.layer.cornerRadius = 5;
    [_detailBtn setTitleColor:UIColorFromRGB(0x5795E6) forState:UIControlStateNormal];
    _detailBtn.layer.borderColor = UIColorFromRGB(0x5795E6).CGColor;
}
- (IBAction)detailBtnClicked:(id)sender {
    
    _detailBlock(_dataModel.detail);
}
- (void)setItemModel:(ReportItemModel *)itemModel{
    
    _itemModel = itemModel;
    self.dataModel = itemModel.data;
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    
    if (_itemModel.caption) {
        _legendView.hidden = NO;
        _captionLabel.hidden = NO;
        _topCon.constant = 40;
        if (_dataModel.detail) {
            _detailBtn.hidden = NO;
        }else{
            _detailBtn.hidden = YES;
        }
        if (_itemModel.caption.left) {
            //居左
            _captionLabel.backgroundColor = [UIColor whiteColor];
            _captionLabel.textColor = UIColorHex(@"008fed");
            _captionLabel.textAlignment = NSTextAlignmentLeft;
            _captionLabel.text = [NSString stringWithFormat:@"    %@",_itemModel.caption.text];
        }else{
            //居中
            _captionLabel.backgroundColor = RGBCOLOR(207, 245, 222);
            _captionLabel.textColor = UIColorHex(@"212121");
            _captionLabel.textAlignment = NSTextAlignmentCenter;
            _captionLabel.text = _itemModel.caption.text;
        }
    }else{
        _legendView.hidden = YES;
        _topCon.constant = 0;
    }
    
    NSInteger num = 7;
    if (_colNum == 5) {
        num = 35;
    }
    
    NSLog(@"%@",dataModel);
    NSMutableArray *dateArr=[NSMutableArray array];
    int index = 0;
    for (int i=0; i<num; i++) {
        
        
        if (num == 35) {
            if ((i + 1) % 5 == 0) {
                NSDictionary *dic  = dataModel.abscissa[index];
                [dateArr addObject:dic[@"label"]];
                index++;
            }else{
                [dateArr addObject:@""];
            }
        }else{
            NSDictionary *dic  = dataModel.abscissa[i];
            [dateArr addObject:dic[@"label"]];
        }
    }
//    NSMutableArray *dateArr=[NSMutableArray array];
//    for (NSDictionary *dic in dataModel.abscissa) {
//        [dateArr addObject:dic[@"label"]];
//    }
    NSMutableArray *yNameArr=[NSMutableArray array];
    NSMutableArray *yDataArr=[NSMutableArray array];
    for (NSDictionary *dic in dataModel.ordinate) {
        [yNameArr addObject:dic[@"label"]];
        [yDataArr addObject:dic[@"coordinate"]];
    }
   
    NSMutableArray *dataArr=[NSMutableArray array];
    NSMutableArray *testVHArr=[NSMutableArray array];
    
    for (int i=0; i<num; i++) {
        NSMutableArray  *arrM=[NSMutableArray arrayWithObjects:@"0",@"0", nil];
        [dataArr addObject:arrM];
        [testVHArr addObject:@"0"];
    }
   
    for (NSDictionary *dic in dataModel.data) {
//        [dataArr replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[dic[@"x"] intValue]] withObjects:@[dic[@"y"],dic[@"max"]]];
        [dataArr replaceObjectAtIndex:[dic[@"x"] intValue] withObject:@[dic[@"y"],dic[@"max"]]];
        [testVHArr replaceObjectAtIndex:[dic[@"x"] intValue] withObject:dic[@"min"]];
    }
    if ([[yNameArr firstObject]intValue] == 0) {
        [yNameArr removeObjectAtIndex:0];
    }
    if ([[yDataArr firstObject] intValue] == 0) {
        [yDataArr removeObjectAtIndex:0];
    }
    JHColumnChart *column;
    if (self.width>0&&self.height>0) {
        column=[[JHColumnChart alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    }else{
        column=[[JHColumnChart alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    }
    
    column.maxHeight=[dataModel.ordinate.lastObject[@"coordinate"] floatValue];
    column.yName=dataModel.ylabel;
    column.yNameArr=yNameArr;
//    column.valueArr = @[
//                        @[@2244,@2450],
//                        @[@1260,@60],
//                        @[@42,@60],
//                        @[@50,@60],
//                        @[@20,@60],
//                        @[@80,@70],
//                        @[@30,@50]
//                        ];
    column.testViewHArr=testVHArr;
    column.valueArr=dataArr;
    column.yDataArr=yDataArr;
    if (_colNum == 5) {
       column.typeSpace=5;
    }else{
//        column.typeSpace=28;
        column.typeSpace=5;
    }
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(30, 30);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 10;
    /*        Column width         */
    if (_colNum == 5) {
        column.columnWidth = 5;
    }else{
//         column.columnWidth = 20;
        column.columnWidth=(kScreenWidth-30-20-5*(dateArr.count-1))/dateArr.count/2;
    }
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor whiteColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = UIColorHex(@"666666");
    /*        X, Y axis line color         */
    column.colorForXYLine = UIColorHex(@"000000");
    column.dashColor=UIColorHex(@"41d07d");
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    column.columnBGcolorsArr = @[UIColorHex(@"FFB434"),UIColorHex(@"4dd0e1")];
    /*        Module prompt         */
    column.xShowInfoText = dateArr;
    if ([dataModel.legend count] > 0) {
        column.isHiddenLegend=NO;
        for (NSDictionary *dic in dataModel.legend) {
            if ([dic[@"color"] intValue]  == 2) {
                column.blueName=dic[@"label"];
                yellowName=dic[@"label"];
            }
            if ([dic[@"color"] intValue]  == 1) {
                column.yellowName=dic[@"label"];
                blueName=dic[@"label"];
            }
        }

    }else{
        column.isHiddenLegend=YES;
    }
    
    
    
    /*       Start animation        */
    [column showAnimation];
    [self.t18View addSubview:column];
    [self creatHeadViewWithBlueName:blueName yellowName:yellowName isHidden:[dataModel.legend count] > 0?NO:YES];
}
-(void)creatHeadViewWithBlueName:(NSString *)blueNameStr yellowName:(NSString *)yellowNameStr isHidden:(BOOL)hidden{
    
    CGFloat y = 15;
    if (_itemModel.caption) {
        
        y += 40;
    }
    
    //您的标准区间
    CGFloat rightLblLen = [[NSString stringWithFormat:@"%@",blueNameStr] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    CGFloat border=0;
    if (_width>0.0) {
        border=160;
    }
    UILabel *rightLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-10-rightLblLen-border, y, rightLblLen, 20)];
    rightLbl.text=blueNameStr;
    rightLbl.font=[UIFont systemFontOfSize:12];
    //                nameLbl.backgroundColor=[UIColor yellowColor];
    rightLbl.textColor=[UIColor lightGrayColor];
    [self addSubview:rightLbl];
    //您的标准区间颜色
    UILabel *rightLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-20-rightLblLen-40-border, y, 40, 20)];
    rightLblColor.text=@"";
    //                nameLbl.font=[UIFont systemFontOfSize:14];
    rightLblColor.backgroundColor=UIColorHex(@"5593E8");
    //                nameLbl.textColor=[UIColor blueColor];
    [self addSubview:rightLblColor];
    //您的值
    CGFloat leftLblLen = [[NSString stringWithFormat:@"%@",yellowNameStr] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    
    UILabel *leftLbl=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70-rightLblLen-leftLblLen-border, y, leftLblLen, 20)];
    leftLbl.text=yellowNameStr;
    leftLbl.font=[UIFont systemFontOfSize:12];
    //                nameLbl.backgroundColor=[UIColor yellowColor];
    leftLbl.textColor=[UIColor lightGrayColor];
    [self addSubview:leftLbl];
    //您的值颜色
    UILabel *leftLblColor=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120-rightLblLen-leftLblLen-border, y, 40, 20)];
    leftLblColor.text=@"";
    leftLblColor.font=[UIFont systemFontOfSize:12];
    leftLblColor.backgroundColor=UIColorHex(@"FFB434");
    //                leftLblColor.textColor=[UIColor lightGrayColor];
    [self addSubview:leftLblColor];
    
    leftLbl.hidden=hidden;
    leftLblColor.hidden=hidden;
    rightLbl.hidden=hidden;
    rightLblColor.hidden=hidden;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
