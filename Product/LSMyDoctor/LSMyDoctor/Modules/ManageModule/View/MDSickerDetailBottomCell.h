//
//  MDSickerDetailBottomCell.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDSickerDetailBottomCellDelegate <NSObject>
/**
 *  患者近7天报告按钮点击方法
 */
- (void)mDSickerDetailBottomCellSevenReportBtnClickWithBtn:(WFHelperButton*)sender;

/**
 *  患者病历按钮点击方法
 */
- (void)mDSickerDetailBottomCellSickerMedicalRecordBtnClickWithBtn:(WFHelperButton*)sender;

/**
 *  我的医嘱按钮点击方法
 */
- (void)mDSickerDetailBottomCellMyAdviceBtnClickWithBtn:(WFHelperButton*)sender;

@end

@interface MDSickerDetailBottomCell : UITableViewCell

//代理方法
@property (strong,nonatomic) id<MDSickerDetailBottomCellDelegate>delegate;

@end
