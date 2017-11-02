//
//  CureSelCollectionViewCell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/13.
//
//
//  治愈系统选项内容单元格
#import <UIKit/UIKit.h>

@interface CureSelCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,assign) NSInteger row;

@property (nonatomic,copy) NSString *answerText;
@property (nonatomic,copy) NSString *remindStr;

@property (nonatomic,assign) BOOL isSelected;//是否选中

@property (nonatomic,assign) BOOL isAnFlag;//是否为排他项

@end
