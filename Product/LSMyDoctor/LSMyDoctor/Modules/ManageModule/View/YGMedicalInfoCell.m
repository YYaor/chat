//
//  YGMedicalInfoCell.m
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/10.
//
//

#import "YGMedicalInfoCell.h"
@interface YGMedicalInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *registInfoLab;//挂号信息
@property (weak, nonatomic) IBOutlet UILabel *vistTimeLab;//就诊时间
@property (weak, nonatomic) IBOutlet UILabel *projectAndNameLab;//科室和姓名
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLab;//医院姓名



@end

@implementation YGMedicalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(YGMedicalRecordDetailModel *)detailModel
{
    _detailModel = detailModel;
    self.registInfoLab.text = detailModel.outpatient_type;
    self.vistTimeLab.text = detailModel.visit_date;
    self.projectAndNameLab.text = [NSString stringWithFormat:@"%@   %@",detailModel.department_name,detailModel.doctor_name];
    self.hospitalNameLab.text = detailModel.hospital_name;
    
}



@end
