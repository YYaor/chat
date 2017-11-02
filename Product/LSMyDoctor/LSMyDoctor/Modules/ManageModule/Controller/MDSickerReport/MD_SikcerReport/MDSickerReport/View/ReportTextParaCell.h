//
//  ReportTextParaCell.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/28.
//
//

#import <UIKit/UIKit.h>

@interface ReportTextParaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (nonatomic,strong) ReportItemModel *itemModel;
@property (nonatomic,copy) NSString *textStr;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@end
