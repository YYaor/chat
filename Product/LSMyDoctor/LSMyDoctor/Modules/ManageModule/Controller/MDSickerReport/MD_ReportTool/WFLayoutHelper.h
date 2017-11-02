//
//  WFLayoutHelper.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/12.
//
//

/**
 *  创建本类的主要目的是便于读取归档的文件
 */

#import <Foundation/Foundation.h>
#import "AppLayoutModel.h"
#import "QuestionnaireModel.h"

@interface WFLayoutHelper : NSObject

//用于
@property (nonatomic,strong) AppLayoutModel *LayoutModel;

@property (nonatomic,copy) NSString *filePath;

- (instancetype)initWithFilePath:(NSString *) filePath;

#pragma mark - 帮助方法
//获取模块布局模型
- (AppLayoutModel *)getAppLayoutModel;
//解归档获取顶级的appSubLayout子布局
- (NSArray *)getSubLayouts;
//解归档获取布局版本号
- (NSInteger)getLayoutVersion;
//根据模块moduleId获取模块问卷的QNId
- (NSInteger)getQNIdByModuleId:(NSInteger) moduleId;
//根据问卷名称获取问卷的QNId
- (NSInteger)getQNIdByQNName:(NSString *) qnName ModuleId:(NSInteger) moduleId;
//根据id获取自愈问卷
- (NSInteger)getQNCode;
//图文混排:富文本显示文字和图片
+ (NSAttributedString *) mixImage:(UIImage *) image text:(NSString *) text fontSize:(CGFloat) fontSize;//文前图后
+ (NSAttributedString *) mixImageFront:(UIImage *) image textBack:(NSString *) text;//图前文后
+ (NSAttributedString *) mixImageFront:(UIImage *) image textBack:(NSString *) text font:(CGFloat) font;
//记录模块访问日志
+ (void)recordModuleAskLogWithModuleId:(NSString *) moduleId ModuleName:(NSString *)moduleName;
//清除答案
+ (void)clearAnswerWithGroupDataModel:(GroupDataModel *) groupModel;
//GroupDataModel至少填写一题
+ (BOOL)isHasRecordWithGroupDataModel:(GroupDataModel *) groupModel;
//请选择必选题:YES -- 已填写,NO -- 未填写
+ (BOOL)isDoReqiureQuestionOfGroupModel:(GroupDataModel *) groupModel;
//第一个必选题的位置
+ (NSIndexPath *)getFirRequiredQNOfGroupModel:(GroupDataModel *) groupModel;

@end
