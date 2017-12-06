//
//  YGMedicalRecordListModel.h
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/9.
//
//

#import <Foundation/Foundation.h>

@interface YGMedicalRecordListModel : NSObject<YYModel>

@property (nonatomic,strong) NSString *chief_complaint;
@property (nonatomic,strong) NSString *is_pharmacy;
@property (nonatomic,strong) NSString *department_name;
@property (nonatomic,strong) NSString *diagnosis;
@property (nonatomic,strong) NSString *is_checked;
@property (nonatomic,strong) NSString *recordId;
@property (nonatomic,strong) NSString *doctor_name;
@property (nonatomic,strong) NSString *visit_date;
@property (nonatomic,strong) NSString *hospital_name;


@property (nonatomic,assign) BOOL isSelected;

@end
