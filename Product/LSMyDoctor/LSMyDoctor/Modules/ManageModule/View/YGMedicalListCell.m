//
//  YGMedicalListCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/8.
//
//

#import "YGMedicalListCell.h"
@interface YGMedicalListCell()

@property (weak, nonatomic) IBOutlet UILabel *projectNameLab;//科室 -- 骨科
@property (weak, nonatomic) IBOutlet UILabel *doctorResultLab;//医生诊断结果
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间
@property (weak, nonatomic) IBOutlet UILabel *valueLab;//主诉内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueHeight;//主诉内容的高度
@property (weak, nonatomic) IBOutlet UILabel *hopitalNameLab;//医院名称
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLab;//医生姓名
@property (weak, nonatomic) IBOutlet UILabel *inspectLab;//检
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inspectLabHeight;//捡的高度
@property (weak, nonatomic) IBOutlet UILabel *medicalLab;//药
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *medicalLabHeight;//药的高度



@end

@implementation YGMedicalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.inspectLab.layer.masksToBounds = YES;
    self.inspectLab.layer.cornerRadius = 12.0f;
    self.medicalLab.layer.masksToBounds = YES;
    self.medicalLab.layer.cornerRadius = 12.0f;
    
    
    // Initialization code
}

- (void)setModel:(YGMedicalRecordListModel *)model
{
    _model = model;
    self.projectNameLab.text = model.department_name;
    self.timeLab.text = model.visit_date;
    self.hopitalNameLab.text = model.hospital_name;
    self.doctorNameLab.text = [NSString stringWithFormat:@"%@  医生",model.doctor_name];
    if (model.chief_complaint) {
        self.valueLab.text = model.chief_complaint;
        
    }else{
        self.valueLab.text = @"暂无主诉内容";
        self.valueHeight.constant = 35.0f;
    }
    
    self.doctorResultLab.text = model.diagnosis;
    
    if ([model.is_checked boolValue] && [model.is_pharmacy boolValue]) {
        self.inspectLab.text = @"检";
        self.medicalLab.text = @"药";
        self.inspectLab.hidden = self.medicalLab.hidden = NO;
        self.inspectLabHeight.constant = self.medicalLabHeight.constant = 24.0f;
    }else if (![model.is_checked boolValue] && ![model.is_pharmacy boolValue]){
        self.inspectLab.text = @"";
        self.medicalLab.text = @"";
        self.inspectLab.hidden = self.medicalLab.hidden = YES;
        self.inspectLabHeight.constant = self.medicalLabHeight.constant = 0.0f;
    }else{
        self.medicalLab.text = @"";
        self.inspectLab.hidden = NO;
        self.medicalLab.hidden = YES;
        self.inspectLabHeight.constant = 24.0f;
        self.medicalLabHeight.constant = 0.0f;
        self.inspectLab.text = [model.is_checked boolValue] ? @"检" : @"药";
    }
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
