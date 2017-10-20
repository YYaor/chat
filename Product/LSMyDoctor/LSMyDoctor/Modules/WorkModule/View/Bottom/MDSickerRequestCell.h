//
//  MDSickerRequestCell.h
//  MyDoctor
//
//  Created by 惠生 on 17/7/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPeerReuqestModel.h"

@protocol MDSickerRequestCellDelegate <NSObject>
/**
 *  点击同意按钮代理方法
 */
- (void)mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:(MDRequestContentModel *)contentModel;

@end

@interface MDSickerRequestCell : UITableViewCell

@property (nonatomic ,strong) MDRequestContentModel* contentModel;

//代理方法
@property (strong,nonatomic) id<MDSickerRequestCellDelegate>delegate;//输入代理

@end
