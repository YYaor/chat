//
//  T24Cell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/12/8.
//
//

#import "T24Cell.h"
#import "JHChartHeader.h"
#import "ZPLineChart.h"

@interface T24Cell ()

@property (weak, nonatomic) IBOutlet UIView *t24View;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation T24Cell

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
    
    NSLog(@"%@",dataModel);
    NSMutableArray *dateArr=[NSMutableArray array];
    for (NSDictionary *dic in dataModel.abscissa) {
        [dateArr addObject:dic[@"label"]];
    }
    NSMutableArray *yNameArr=[NSMutableArray array];
    for (NSDictionary *dic in dataModel.ordinate) {
        [yNameArr addObject:dic[@"label"]];
    }
    NSMutableArray *colorArr=[NSMutableArray array];
    NSMutableArray *dataArr=[NSMutableArray array];
    NSDictionary *dic=dataModel.data.lastObject;
    for (int i =0; i<=[dic[@"x"] intValue]; i++) {
        [dataArr addObject:@""];
    }
    for (NSDictionary *dic in dataModel.data) {
        [dataArr replaceObjectAtIndex:[dic[@"x"] intValue] withObject:[NSString stringWithFormat:@"%@",dic[@"y"]]];
        if ([dic[@"color"] intValue] != 1) {
            [colorArr addObject:dic[@"x"]];
        }
    }
        JHLineChart *aaalineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) andLineChartType:JHChartLineValueNotForEveryX];
        aaalineChart.yNameArr=[[yNameArr reverseObjectEnumerator] allObjects];
        aaalineChart.xLineDataArr = dateArr;
        aaalineChart.yName=dataModel.ylabel;
        aaalineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    
//        aaalineChart.valueArr = @[@[@-2,@-1,@0,@1,@2]];
        aaalineChart.valueArr = @[dataArr];
        aaalineChart.yLineDataArr=@[@[@"-2",@"-1",@"0",@"1",@"2"]];
        aaalineChart.valueLineColorArr =@[ [UIColor purpleColor],UIColorHex(@"5593E8")];
        /* Colors for every line chart*/
        aaalineChart.pointColorArr = @[UIColorHex(@"5593E8"),[UIColor yellowColor]];
        /* color for XY axis */
        aaalineChart.xAndYLineColor = UIColorHex(@"41d07d");
        /* XY axis scale color */
        aaalineChart.xAndYNumberColor = UIColorHex(@"666666");
        /* Dotted line color of the coordinate point */
        aaalineChart.positionLineColorArr = @[UIColorHex(@"5593E8"),[UIColor greenColor]];
        /*        Set whether to fill the content, the default is False         */
        aaalineChart.contentFill = NO;
        /*        Set whether the curve path         */
        aaalineChart.pathCurve = NO;
        /*        Set fill color array         */
        aaalineChart.contentFillColorArr = @[[UIColor colorWithRed:0.500 green:0.000 blue:0.500 alpha:0.468],[UIColor colorWithRed:0.500 green:0.214 blue:0.098 alpha:0.468]];
        [_t24View addSubview:aaalineChart];
        /*       Start animation        */
        [aaalineChart showAnimation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
