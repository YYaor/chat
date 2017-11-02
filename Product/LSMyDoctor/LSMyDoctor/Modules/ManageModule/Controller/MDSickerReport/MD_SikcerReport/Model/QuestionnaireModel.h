//
//  QuestionnaireModel.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/14.
//
//

#import <Foundation/Foundation.h>

@interface AgeModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic,assign) NSInteger min;//最小
@property (nonatomic,assign) NSInteger max;//最大

@end

//答案
@interface AnswerModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic,copy)NSString *anCode;//选项答案代码或ID
@property (nonatomic,copy)NSString *anDefault;//答案默认值
@property (nonatomic,assign)BOOL anFlag;//排它标志
@property (nonatomic,copy)NSString *anFormat;//格式显示
@property (nonatomic,copy)NSString *anGetDefault;//获取默认值
@property (nonatomic,copy)NSString *anMultiRow;//是否多行
@property (nonatomic,copy)NSString *anReminder;//提示
@property (nonatomic,assign) NSInteger anSeq;//排序
@property (nonatomic,assign) NSInteger anType;//类型
@property (nonatomic,copy)NSString *anUnit;//显示单位
@property (nonatomic,copy)NSString *anUrl;//跳转路径
@property (nonatomic,copy)NSString *max;//最大值（类型数字区间）
@property (nonatomic,copy)NSString *min;//最小值（数字区间）
@property (nonatomic,copy)NSString *step;//步长（数字区间）
@property (nonatomic,copy)NSString *anName;//显示名称
@property (nonatomic,copy)NSString *anImgUrl;//图片地址
@property (nonatomic,assign) BOOL isAnRela;//是否为关联选项
@property (nonatomic,assign) NSInteger anLength;//输入框长度限制

@property (nonatomic,copy) NSString *SaveValue;//保存值
@property (nonatomic,assign) BOOL SaveFlag;//保存标记

@property (nonatomic,assign) BOOL isSelected;//是否选中
@property (nonatomic,assign) BOOL isRelaed;//是否已经关联子题


@end

//关联问题
@interface RelaQuestModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic,copy) NSString *relaType;
@property (nonatomic,copy) NSString *relaCode;
@property (nonatomic,copy) NSArray *relaData;//GroupDataModel

@end


@interface QuestionModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic,copy) NSString *keycode;
@property (nonatomic,copy) NSString *imgUrl;//问题图片
@property (nonatomic,copy) NSString *code;//问题代码
@property (nonatomic,assign) NSInteger type;//1单选2多选3排它4时间时长5数值区间，6输入框7图片跳转8附件9图片点击10组合
@property (nonatomic,copy) NSString *sex;//适用性别要求
@property (nonatomic,copy) NSString *title;//问题标题
@property (nonatomic,copy) NSArray *anInfo;//AnswerModel 选项答案信息
@property (nonatomic,strong) NSArray *rela;//RelaQuestModel 关联数据集
@property (nonatomic,assign) NSInteger seq;//排序序号
@property (nonatomic,assign) BOOL required;//是否必填
@property (nonatomic,strong) AgeModel *age;//适用年龄段
@property(nonatomic,copy) NSString *remark;//备注
@property(nonatomic,copy) NSString *reminder;//提示
@property (nonatomic,assign) NSInteger style;//显示样式
@property (nonatomic,assign) BOOL isFold;//是否展开了
//@property (nonatomic,copy) NSString *labels;//题目标签，标签20位代码10010000100000101010

@property (nonatomic,assign) BOOL isShow;//是否隐藏  0为显示  1为隐藏
@property (nonatomic,assign) BOOL isFeedBack;//是否反馈
@property (nonatomic,assign) BOOL isRequired;//题目是否已填
@property (nonatomic,assign) BOOL isSaveFlag;//保存标记

//保存结果的值
@property (nonatomic,copy) NSString *resultStr;
//@property (nonatomic,copy) NSString *numResult;//数值滚轮的值
//@property (nonatomic,copy) NSString *hourResult;//时间-小时值
//@property (nonatomic,copy) NSString *minResult;//时间-分值
//@property (nonatomic,copy) NSString *inputString;//输入框结果
//@property (nonatomic,copy) NSArray *picsArray;//插入图片结果

@property (nonatomic,assign) BOOL isRelated;//是否已经关联题目

@property (nonatomic,copy) NSString *groupCode;

@property (nonatomic,assign) BOOL isGetDefault;//是否选中默认值

#pragma mark - modify
@property (nonatomic,assign) BOOL isRelaQuestion;//是否为关联出的子题
@property (nonatomic,copy) NSString *titleNumString;//题目父标题序号
@property (nonatomic,assign) NSInteger row;

@end

@interface GroupDataModel : NSObject<YYModel,NSCoding,NSCopying>

@property (nonatomic,copy) NSArray *groupDatas;//QuestionModel 组数据集，如果不是组也是相同格式.
@property (nonatomic,copy) NSString *groupID;//组的ID
@property (nonatomic,copy) NSString *groupName;//组名称
@property (nonatomic,assign) NSInteger groupSeq;//排序
@property (nonatomic,assign) NSInteger groupType;//类型:1表示题目，2表示组
@property (nonatomic,assign) NSInteger groupShowStyle;//0不显示标题1普通,2可动态添加3单独显示弹出记录4指标列表显示
@property (nonatomic,copy) NSString *groupCode;//组代码
@property (nonatomic,assign) NSInteger groupPC;//动态添加组批次

#pragma mark - modify
@property (nonatomic,assign) NSInteger relaNum;//已关联几个


@end

@interface QuestionnaireModel : NSObject<YYModel,NSCoding>

@property (nonatomic,assign) NSInteger QNId;

@property (nonatomic,copy) NSString *QNCode;//问卷代码或ID

@property (nonatomic,copy) NSString *QNName;//问卷名

@property (nonatomic,copy) NSArray *QNData;//问卷的问题数据 GroupDataModel

//本地问卷保存时需要保存的数据
@property (nonatomic,assign) NSInteger saveDate;//保存日期
@property (nonatomic,copy) NSString *userKey;//用户唯一标识
@property (nonatomic,copy) NSArray *dataArray;//问卷数据源数组

@end
