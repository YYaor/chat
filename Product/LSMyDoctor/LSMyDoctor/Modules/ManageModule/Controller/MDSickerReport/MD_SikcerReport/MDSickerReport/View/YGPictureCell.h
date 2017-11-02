//
//  YGPictureCell.h
//  YouGeHealth
//
//  Created by 惠生 on 16/11/11.
//
//

#import <UIKit/UIKit.h>
@protocol yGPictureCellDelegate <NSObject>

- (void)yGPictureCellDetailBtnClickWithUrl:(NSString*)urlStr image:(UIImage *)image;//下方按钮传值方法

@end

@interface YGPictureCell : UITableViewCell

@property (nonatomic,copy) NSMutableArray *mutArr;

//代理方法
@property (strong,nonatomic) id<yGPictureCellDelegate>delegate;//点击图片按钮传值

@end
