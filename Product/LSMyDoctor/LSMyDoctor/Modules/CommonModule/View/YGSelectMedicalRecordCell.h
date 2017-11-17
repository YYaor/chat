//
//  YGSelectMedicalRecordCell.h
//  YouGeHealth
//
//  Created by WangQuanjiang on 2017/11/15.
//
//

#import "EaseBaseMessageCell.h"

@protocol YGSelectMedicalRecordCellDelegate <NSObject>

- (void)yGSelectMedicalRecordCellDetailBtnClick:(WFHelperButton*)sender;

@end

@interface YGSelectMedicalRecordCell : EaseBaseMessageCell
//代理方法
@property (strong,nonatomic) id<YGSelectMedicalRecordCellDelegate>delegate;

@end
