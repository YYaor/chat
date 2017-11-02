//
//  YGLongitudinalListCell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/11/11.
//
//

#import "YGLongitudinalListCell.h"

#define cellHeight 60
@interface YGLongitudinalListCell ()

@property (weak, nonatomic) IBOutlet UIView *captionView;//caption头部标题视图
@property (weak, nonatomic) IBOutlet UIView *reportView;//报告视图
@property (weak, nonatomic) IBOutlet UILabel *legentLab;//底部约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportHeight;//报告视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;//caption的高度




@end

@implementation YGLongitudinalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//新增....
- (void)setItemModel:(ReportItemModel *)itemModel
{
    _itemModel = itemModel;
    ReportCaptionModel *captionModel = itemModel.caption;
    
    for (UIView *v in self.captionView.subviews) {
        [v removeFromSuperview];
    }
    
    //头部标题
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.textColor = Style_Color_Content_Black;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.text = captionModel.text;
    if (captionModel.left) {
        titleLab.textAlignment = NSTextAlignmentLeft;
    }else{
        titleLab.textAlignment = NSTextAlignmentCenter;
    }
    [self.captionView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.captionView.mas_left);
        make.top.equalTo(self.captionView.mas_top);
        make.right.equalTo(self.captionView.mas_right);
        make.bottom.equalTo(self.captionView.mas_bottom);
    }];
    
    
    if (captionModel.text.length <= 0) {
        self.titleHeight.constant = 0;
    }
    
    self.dataModel = itemModel.data;
 
    
}

- (void)setDataModel:(ReportItemDataModel *)dataModel
{
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    for (UIView *v in self.reportView.subviews) {
        [v removeFromSuperview];
    }
    self.reportHeight.constant = dataModel.list.count * cellHeight;
    
    for (int i = 0; i < self.dataModel.list.count; i++) {
        //判断是否符合标准
        if ([self.dataModel.list[i] isKindOfClass:[NSDictionary class]]) {
            
            self.dict = self.dataModel.list[i];
            
            //创建每一行View
            UIView* longView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight * i, kScreenWidth, cellHeight)];
//            longView.backgroundColor = [UIColor yellowColor];
            [self.reportView addSubview:longView];
            
            //创建nameLab
            UILabel* nameLab = [[UILabel alloc] init];
            nameLab.text = self.dict[@"name"];
            nameLab.textColor = [UIColor darkGrayColor];
            nameLab.font = [UIFont systemFontOfSize:17];
            [longView addSubview:nameLab];
            [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(longView.mas_top);
                make.left.equalTo(longView.mas_left).offset(6);
                make.right.equalTo(longView.mas_right);
                make.height.equalTo(@25);
            }];
            
            
            
            
            UILabel* valueLab = [[UILabel alloc] init];
            //拿value的数据
            NSArray* valuesArr = self.dict[@"values"];
            if (valuesArr.count > 0) {
                
                NSString* valuesStr = self.dict[@"values"][0];
                for (int i = 1; i < valuesArr.count; i++) {
                    valuesStr = [NSString stringWithFormat:@"%@、%@",valuesStr,valuesArr[i]];
                }
                valueLab.text = valuesStr;
                
            }
            
            
            valueLab.textColor = Style_Color_Content_Black;
            valueLab.font = [UIFont systemFontOfSize:15];
            valueLab.numberOfLines = 0;
            [longView addSubview:valueLab];
            [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(nameLab.mas_bottom);
                make.left.equalTo(longView.mas_left).offset(6);
                make.right.equalTo(longView.mas_right);
                make.bottom.equalTo(longView.mas_bottom);
            }];
            
            
            
            
            
        }
        
        
        
        
    }//for循环结束
    
    
}

//- (void)setDict:(NSDictionary *)dict{
//
//    _dict = dict;
//
//    _nameLab.text = dict[@"name"];
//    NSArray* valuesArr = dict[@"values"];
//    if (valuesArr.count > 0) {
//
//        NSString* valuesStr = dict[@"values"][0];
//        for (int i = 1; i < valuesArr.count; i++) {
//            valuesStr = [NSString stringWithFormat:@"%@、%@",valuesStr,valuesArr[i]];
//        }
//        _valueLab.text = valuesStr;
//        
//    }
//   
//    //[_valueLab sizeToFit];
//    NSLog(@"dict:%@",self.dict);
//    
////    NSMutableString *mutStr = [[NSMutableString alloc] init];
////    NSArray *values = dict[@"values"];
////    for (int i = 0; i < values.count; ++i) {
////        NSString *str = values[i];
////        [mutStr appendString:str];
////        if (i != values.count - 1) {
////            [mutStr appendString:@"、"];
////        }
////    }
////    
////    _leftLabel.text = dict[@"name"];
////    _rightLabel.text = mutStr;
//}


@end
