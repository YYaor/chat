//
//  YGT32Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 17/3/1.
//
//

#import "YGT32Cell.h"
#import "PieCharVIew.h"
#import "PieCharModel.h"

@interface YGT32Cell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题

@property (weak, nonatomic) IBOutlet UIView *reportView;//饼状图View

@property (weak, nonatomic) IBOutlet UIView *legendView;//图例View

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legendViewHeight;//高度



@end

@implementation YGT32Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemModel:(ReportItemModel *)itemModel
{
    _itemModel = itemModel;
    NSLog(@"%@",itemModel);
    
    ReportCaptionModel *captionModel = itemModel.caption;
    
    _titleLab.text = captionModel.text;//标题
    
    self.dataModel = itemModel.data;
    
}

- (void)setDataModel:(ReportItemDataModel *)dataModel
{
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSMutableArray *positionArray = [NSMutableArray array];
    NSMutableArray *colorArray = [NSMutableArray array];
    //颜色数组
    [colorArray addObject:UIColorFromRGB(0x5693e8)];
    [colorArray addObject:UIColorFromRGB(0xf5a083)];
    [colorArray addObject:UIColorFromRGB(0xa5cfdf)];
    [colorArray addObject:UIColorFromRGB(0x41d07e)];
    [colorArray addObject:UIColorFromRGB(0xffb434)];
    [colorArray addObject:UIColorFromRGB(0xbf9a7f)];
    [colorArray addObject:UIColorFromRGB(0xff7d51)];
    [colorArray addObject:UIColorFromRGB(0x56c6c7)];
    [colorArray addObject:UIColorFromRGB(0xff80ab)];
    
    
    for (NSDictionary* dict in dataModel.list) {
        [titleArray addObject:dict[@"name"]];
        [positionArray addObject:dict[@"YouAreHere"]];
        [valueArray addObject:[NSString stringWithFormat:@"%@",dict[@"value"]]];
        
    }
    
    
    
    //饼状图
    
    NSMutableArray *dataArry = [NSMutableArray array];
    PieCharView *pieChar = [[PieCharView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, kScreenWidth)];
    pieChar.textColor = Style_Color_Content_Black;
    pieChar.textFont = 17.0f;
    pieChar.radius = (kScreenWidth - 140)/2;
    [self.reportView addSubview:pieChar];
    
    for (int i = 0; i < titleArray.count; i ++) {
        PieCharModel *model = [[PieCharModel alloc] init];
        model.title = [NSString stringWithFormat:@"%@%%",valueArray[i]];
        model.percent = [NSString stringWithFormat:@"%f",[valueArray[i] floatValue]/100];
        model.color = colorArray[i];
        model.yourPositionHidden = !(BOOL)[positionArray[i] integerValue];
        [dataArry addObject:model];
    }
    
    pieChar.dataArray = dataArry;
    
    
    //图例
    for (UIView *v in self.legendView.subviews) {
        [v removeFromSuperview];
    }
    
    
    //先将您的位置和标题放到数组内。
    NSMutableArray* markArray = titleArray;
    [markArray addObject:@"您的位置"];
    //计算行数，向上取整
    
    CGFloat numRow = 1;
    if (markArray.count >= 3) {
        numRow = ceilf((float)markArray.count/3);
    }
    
    self.legendViewHeight.constant = 40*numRow;//设置高度
    
    for (int i = 0; i <= numRow; i ++) {//几行
        
        for (int j = 0; j <= 3; j++) {//几列
            
            if (3 * j + i <= markArray.count - 1 ) {
                //以颜色标记+说明为单位创建View
                CGFloat markWidth = (kScreenWidth - 5*6)/3;//每一个View的高度
                CGFloat xPos = 5 + (markWidth + 5)*i;
                UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(xPos, 30*j, markWidth, 30)];
                
                //显示颜色标记
                UIImageView* markImgView = [[UIImageView alloc] init];
                markImgView.layer.masksToBounds = YES;
                markImgView.layer.cornerRadius = 4.5;
                if (3*j+i == markArray.count - 1) {
                    //您的位置放在数组最后面
                    markImgView.image = [UIImage imageNamed:@"yourposition"];
                    markImgView.contentMode = UIViewContentModeScaleAspectFit;
                }else{
                    markImgView.backgroundColor = colorArray[3*j+i];
                }
                [markView addSubview:markImgView];
                [markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(markView.mas_centerY);
                    make.left.equalTo(@5);
                    make.height.equalTo(markView.mas_height).multipliedBy(0.7);
                    make.width.equalTo(markImgView.mas_height);
                }];
                
                //显示名称
                UILabel* nameLab = [[UILabel alloc] init];
                nameLab.text = markArray[3*j+i];
                nameLab.textColor = Style_Color_Content_Black;
                [markView addSubview:nameLab];
                [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(markView.mas_centerY);
                    make.left.equalTo(markImgView.mas_right).offset(5);
                }];
                
                
                
                [self.legendView addSubview:markView];
            }
            
            
            
        }
        
        
        
    }
    
    
    
    
    
}


@end
