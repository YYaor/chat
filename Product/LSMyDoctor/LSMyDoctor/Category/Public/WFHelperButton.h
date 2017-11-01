//
//  WFHelperButton.h
//  YouGeHealth
//
//  Created by earlyfly on 16/11/1.
//
//

#import <UIKit/UIKit.h>

@interface WFHelperButton : UIButton

@property (nonatomic,assign) NSInteger section;//医生首页使用
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *detail;//点击弹出文字

@property (nonatomic,strong) NSString* flagStr;//标识

@property(nonatomic,assign) BOOL dragEnable;
@property(nonatomic,assign) BOOL adsorbEnable;


@property (nonatomic,copy) NSString *statusStr;//日历按钮状态:0-	状况不佳 1-	状况一般 2-	状况良好 3-	有记录 4- 没有记录
@property (nonatomic,assign)BOOL isEditable;//是否可追记
@property (nonatomic,strong) NSString *picString;

@end
