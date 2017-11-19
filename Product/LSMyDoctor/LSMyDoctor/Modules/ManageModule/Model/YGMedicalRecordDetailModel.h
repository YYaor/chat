//
//  YGMedicalRecordDetailModel.h
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/13.
//
//

#import <Foundation/Foundation.h>

@interface YGMedicalRecordDetailModel : NSObject<YYModel>

@property (nonatomic,strong) NSString *chief_complaint;//主诉
@property (nonatomic,strong) NSString *diagnosis;//医生诊断
@property (nonatomic,strong) NSString *advice;//医嘱
@property (nonatomic,strong) NSString *check_content;//检查检验内容

@property (nonatomic,strong) NSString *is_pharmacy;
@property (nonatomic,strong) NSString *department_name;
@property (nonatomic,strong) NSString *is_checked;
@property (nonatomic,strong) NSString *record_id;
@property (nonatomic,strong) NSString *doctor_name;
@property (nonatomic,strong) NSString *outpatient_type;
@property (nonatomic,strong) NSString *visit_date;
@property (nonatomic,strong) NSString *hospital_name;
@property (nonatomic,strong) NSString *pharmacy;
@property (nonatomic,strong) NSArray *pharmacy_imgs;
@property (nonatomic,strong) NSArray *checke_imgs;

@end

@interface YGMedicalRecordImgModel : NSObject<YYModel>

@property (nonatomic,strong) NSString *img_url;

@end

