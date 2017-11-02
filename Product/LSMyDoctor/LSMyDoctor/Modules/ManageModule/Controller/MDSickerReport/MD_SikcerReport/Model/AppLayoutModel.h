//
//  AppLayoutModel.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/8.
//
//

#import <Foundation/Foundation.h>

@interface AppLayoutParamsModel : NSObject<YYModel,NSCoding>

@property(nonatomic,copy) NSString *appLayoutParamsName;//参数名称
@property(nonatomic,copy) NSString *appLayoutParamsValue;//参数值

@end


@interface ModulesModel : NSObject<YYModel,NSCoding>

@property (nonatomic,strong) NSString *report;
@property (nonatomic,strong) NSString *module;//报告模块唯一标识
@property (nonatomic,copy) NSString *appLayoutId;//布局模块ID
@property (nonatomic,copy) NSArray *appLayoutParams;//AppLayoutParamsModel:布局模块自定义参数
//@property (nonatomic,copy) NSArray *appLayoutImage;//布局模块所用图片数组
@property (nonatomic,copy) NSString *appLayoutParent;//布局模块父级ID
@property (nonatomic,copy) NSString *appLayoutName;//布局模块显示名称
@property (nonatomic,copy) NSString *appLayoutCode;//布局模块代码
@property (nonatomic,copy) NSString *appLayoutStyle;//布局模块显示风格(1 九宫格 2 列表 3轮播广告图)
@property (nonatomic,copy) NSString *appLayoutIcon;//布局模块图标url
@property (nonatomic,copy) NSString *appLayoutIsLogin;//是否登录后可用 0否1是
@property (nonatomic,copy) NSString *appLayoutRemark;//提示语
@property (nonatomic,assign) NSInteger appLayoutSort;//模块排序
@property (nonatomic,copy) NSString *appLayoutType;//布局模块类型(1 菜单 2 导航 3 功能按钮 )
@property (nonatomic,assign) NSInteger appLayoutUsable;//是否可用 0否1是 2已做过
@property (nonatomic,copy) NSString *appLayoutVisible;//是否可见 0否1是
//@property (nonatomic,copy) NSString *appShowResult;//布局排版样式(001 每行排1个。。 以此类推)
@property (nonatomic,copy) NSArray *data;//子模块信息ModulesModel

@end

@interface QuestionnaireInfoModel : NSObject

@property (nonatomic,copy) NSString *Labels;//标签字符串
@property (nonatomic,copy) NSString *QNName;//问卷名称

@property (nonatomic,assign) NSInteger ModuleID;//模块ID
@property (nonatomic,assign) NSInteger QNCode;//问卷ID
@property (nonatomic,assign) NSInteger QNId;

@end

@interface AppLayoutModel : NSObject<YYModel,NSCoding>

@property (nonatomic,copy) NSString *latestNo;//最新版本序列号
@property (nonatomic,strong) ModulesModel *modules;//返回布局数组
@property (nonatomic,copy) NSArray *questionnaire;//QuestionnaireInfoModel



@end
