//
//  YGT22Cell.h
//  YouGeHealth
//
//  Created by 惠生 on 16/12/14.
//
//


///////////////////T22 饮食佑格分+摄入//////////////////////////

#import <UIKit/UIKit.h>
@protocol YGT22CellDelegate <NSObject>

- (void)yGT22CellDetailBtnClickWithButton:(UIButton *)button;//下方按钮传值方法

@end

@interface YGT22Cell : UITableViewCell

@property (nonatomic,strong) ReportItemDataModel *dataModel;

@property (nonatomic, assign) NSInteger IsSimpleNum;//是否为生活日记简版报告
//代理方法
@property (strong,nonatomic) id<YGT22CellDelegate>delegate;//点击下方按钮传值

@end
