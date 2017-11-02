//
//  YGT22Cell.m
//  YouGeHealth
//
//  Created by 惠生 on 16/12/14.
//
//

#import "YGT22Cell.h"

@interface YGT22Cell ()

@property (weak, nonatomic) IBOutlet UILabel *lineLab;//中间分割线

@property (weak, nonatomic) IBOutlet UILabel *scoreNameLab;//饮食佑格分

@property (weak, nonatomic) IBOutlet UILabel *scoreNumLab;//饮食佑格得分（64）

@property (weak, nonatomic) IBOutlet UILabel *todayHaveLab;//今日已摄入

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;//详情按钮

@property (weak, nonatomic) IBOutlet UIView *haveView;//摄入量背景View

@property (weak, nonatomic) IBOutlet UILabel *haveNumLab;//今日摄入量数值（452）

@property (weak, nonatomic) IBOutlet UILabel *qkLab;//千卡

@end

@implementation YGT22Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    //详情按钮处理
    _detailBtn.layer.cornerRadius = 6;
    _detailBtn.layer.borderWidth = 1.0;
    _detailBtn.layer.borderColor = Style_Color_Content_Blue.CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    NSLog(@"%@",dataModel);
    
    self.scoreNameLab.text = dataModel.left_name;
    self.scoreNumLab.text = dataModel.left_value;
    
    if (self.IsSimpleNum == 1) {
        //是简版报告，隐藏详情按钮
        self.detailBtn.hidden = YES;
    }else{
        self.detailBtn.hidden = NO;
    }
    
    [self.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.todayHaveLab.text = dataModel.right_name;
    self.haveNumLab.text = dataModel.right_value;
    self.qkLab.text = dataModel.right_unit;
    
    
}

#pragma mark -- 详情按钮点击方法
- (void)detailBtnClick:(id)sender
{
    NSLog(@"详情按钮点击方法");
    [_delegate yGT22CellDetailBtnClickWithButton:sender];
}

@end
