//
//  MDUsefulMarkCell.h
//  MyDoctor
//
//  Created by 惠生 on 17/7/12.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDUsefulMarkCellDelegate <NSObject>

- (void)mDUsefulMarkCellMarkBtnClick:(WFHelperButton *)sender;//输入框输入完成后方法调用

@end

@interface MDUsefulMarkCell : UITableViewCell

@property (nonatomic ,strong)NSMutableArray* usefulMarkArr;
//代理方法
@property (strong,nonatomic) id<MDUsefulMarkCellDelegate>delegate;//输入代理

@end
