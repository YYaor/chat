//
//  MDHaveMarkCell.h
//  MyDoctor
//
//  Created by 惠生 on 17/7/12.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MDHaveMarkCellDelegate <NSObject>

- (void)mDHaveMarkCellDeleteBtnClick:(WFHelperButton *)sender;//输入框输入完成后方法调用

@end
@interface MDHaveMarkCell : UITableViewCell

@property (nonatomic ,strong)NSMutableArray* haveMarkArr;
//代理方法
@property (strong,nonatomic) id<MDHaveMarkCellDelegate>delegate;//输入代理


@end
