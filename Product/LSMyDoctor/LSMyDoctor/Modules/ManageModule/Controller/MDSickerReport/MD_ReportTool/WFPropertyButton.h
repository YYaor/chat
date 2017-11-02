//
//  WFPropertyButton.h
//  YouGeHealth
//
//  Created by earlyfly on 17/2/23.
//
//

#import <UIKit/UIKit.h>

@interface WFPropertyButton : UIButton

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *statusStr;//日历按钮状态:0-	状况不佳 1-	状况一般 2-	状况良好 3-	有记录 4- 没有记录
@property (nonatomic,assign)BOOL isEditable;//是否可追记
@property (nonatomic,copy) NSString *picString;

@end
