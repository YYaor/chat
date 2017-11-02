//
//  YGCircleCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/8.
//
//

#import "YGCircleCell.h"
#import "YCBCycleView.h"
#import "PieCharView.h"

@interface YGCircleCell ()
{
    YCBCycleView * cycle;
}
@property (weak, nonatomic) IBOutlet UILabel *circleLab;//圆环放置背景图

@end

@implementation YGCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    UILabel* titleLab = [[UILabel alloc] init];
    if (self.titleStr) {
        titleLab.text = self.titleStr;
    }else{
        titleLab.text = @" ";
    }
    titleLab.textColor = Style_Color_Content_Blue;
    [self.circleLab addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.height.equalTo(@25);
        make.left.equalTo(@8);
    }];
    
    
    //环状图
    
//    NSMutableArray* colorArray = [NSMutableArray array];
//    
//    [colorArray addObject:UIColorFromRGB(0x5693e8)];
//    [colorArray addObject:UIColorFromRGB(0xf5a083)];
//    [colorArray addObject:UIColorFromRGB(0xa5cfdf)];
//    [colorArray addObject:UIColorFromRGB(0x41d07e)];
//    [colorArray addObject:UIColorFromRGB(0xffb434)];
//    [colorArray addObject:UIColorFromRGB(0xbf9a7f)];
//    [colorArray addObject:UIColorFromRGB(0xff7d51)];
//    [colorArray addObject:UIColorFromRGB(0x56c6c7)];
//    [colorArray addObject:UIColorFromRGB(0xff80ab)];
//    
//    NSMutableArray *dataArry = [NSMutableArray array];
//    PieCharView *pieChar = [[PieCharView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, kScreenWidth)];
//    pieChar.textColor = Style_Color_Content_TextTitleColor;
//    pieChar.textFont = 17.0f;
//    pieChar.radius = (kScreenWidth - 100)/2;
//    [self.circleLab addSubview:pieChar];
//    
//    for (int i = 0; i < dataModel.list.count; i ++) {
//        PieCharModel *model = [[PieCharModel alloc] init];
//        model.title = [NSString stringWithFormat:@"%@%%",dataModel.list[2][@"name"]];
//        NSString* value = [NSString stringWithFormat:@"%@",dataModel.list[2][@"value"]];
//        model.percent = [NSString stringWithFormat:@"%f",[value floatValue]/100];
//        model.color = colorArray[i];
//        model.yourPositionHidden = YES;
//        [dataArry addObject:model];
//    }
//    pieChar.reportTypeStr = @"T04";
//    pieChar.dataArray = dataArry;
    
    
    
    
    
    
    
    
    
    
    if (cycle) {
        [cycle removeFromSuperview];
        cycle = nil;
    }
    cycle = [[YCBCycleView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth - 50, kScreenWidth - 100)];
    if (dataModel.list.count > 0) {
        
        NSString * value = dataModel.list[2][@"value"];
        cycle.firstTitleStr = dataModel.list[2][@"name"];
        cycle.workDrain = value.floatValue;
        
        NSString * value1 = dataModel.list[1][@"value"];
        cycle.secondTitleStr = dataModel.list[1][@"name"];
        cycle.sportDrain = value1.floatValue;
        
        NSString * value2 = dataModel.list[0][@"value"];
        cycle.thirdTitleStr = dataModel.list[0][@"name"];
        cycle.baseDrain = value2.floatValue;
        
        cycle.unit = dataModel.unit;
        
    }
    
    [self.circleLab addSubview:cycle];
    
    
    
}

@end
