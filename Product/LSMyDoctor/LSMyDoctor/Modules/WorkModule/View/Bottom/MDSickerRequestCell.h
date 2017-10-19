//
//  MDSickerRequestCell.h
//  MyDoctor
//
//  Created by 惠生 on 17/7/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDSickerRequestCellDelegate <NSObject>

//- (void)mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:(MDServiceListModel *)sickerModel;//输入框输入完成后方法调用

@end

@interface MDSickerRequestCell : UITableViewCell


//代理方法
@property (strong,nonatomic) id<MDSickerRequestCellDelegate>delegate;//输入代理

@end
