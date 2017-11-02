//
//  QuestionnaireModel.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/14.
//
//
//问卷模型
#import "QuestionnaireModel.h"

@implementation AgeModel

- (id)copyWithZone:(NSZone *)zone{
    AgeModel *age = [[AgeModel allocWithZone:zone] init];
    age.min = _min;
    age.max = _max;
    return age;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation AnswerModel

-(id)copyWithZone:(NSZone*)zone {
    
    AnswerModel *answer = [[AnswerModel allocWithZone:zone] init];
    answer.anCode = [_anCode copy];
    answer.anDefault = [_anDefault copy];
    answer.anFlag = _anFlag;
    answer.anFormat = [_anFormat copy];
    answer.anGetDefault = [_anGetDefault copy];
    answer.anMultiRow = [_anMultiRow copy];
    answer.anReminder = [_anReminder copy];
    answer.anSeq = _anSeq;
    answer.anType = _anType;
    answer.anUnit = [_anUnit copy];
    answer.anUrl = [_anUrl copy];
    answer.max = [_max copy];
    answer.min = [_min copy];
    answer.step = [_step copy];
    answer.anName = [_anName copy];
    answer.anImgUrl = [_anImgUrl copy];
    answer.isAnRela = _isAnRela;
    answer.anLength = _anLength;
    answer.SaveValue = [_SaveValue copy];
    answer.SaveFlag = _SaveFlag;
    answer.isSelected = _isSelected;
    answer.isRelaed = _isRelaed;
    return answer;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation RelaQuestModel

-(id)copyWithZone:(NSZone*)zone {
    
    RelaQuestModel *rela = [[RelaQuestModel allocWithZone:zone] init];
    rela.relaType = [_relaType copy];
    rela.relaCode = [_relaCode copy];
    NSMutableArray* arr = [NSMutableArray array];
    for (GroupDataModel* temp in _relaData) {
        [arr addObject:[temp copy]];//
    }
    rela.relaData = [arr copy];
    return rela;
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"relaData":[GroupDataModel class]};
}


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation QuestionModel

-(id)copyWithZone:(NSZone*)zone {
    
    QuestionModel *question = [[QuestionModel allocWithZone:zone] init];
    question.keycode = [_keycode copy];
    question.imgUrl = [_imgUrl copy];
    question.code = [_code copy];
    question.type = _type;
    question.sex = [_sex copy];
    question.title = [_title copy];
    
    NSMutableArray* arr1 = [NSMutableArray array];
    for (AnswerModel* temp in _anInfo) {
        [arr1 addObject:[temp copy]];//
    }
    question.anInfo = [arr1 copy];
    
    NSMutableArray* arr2 = [NSMutableArray array];
    for (RelaQuestModel* temp in _rela) {
        [arr2 addObject:[temp copy]];//
    }
    question.rela = [arr2 copy];
    
    question.seq = _seq;
    question.required = _required;
    
    question.age = [_age copy];
    
    question.remark = [_remark copy];
    question.reminder = [_reminder copy];
    
    question.style = _style;
    question.isFold = _isFold;
    question.isShow = _isShow;
    question.isFeedBack = _isFeedBack;
    question.isRequired = _isRequired;
    question.isSaveFlag = _isSaveFlag;
    question.isRelated = _isRelated;
    question.resultStr = [_resultStr copy];
    question.groupCode = [_groupCode copy];
    question.isRelated = _isRelated;
    question.groupCode = _groupCode;
    question.isGetDefault = _isGetDefault;
    question.isRelaQuestion = _isRelaQuestion;
    question.titleNumString = _titleNumString;
    question.row = _row;
    
    return question;
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"anInfo":[AnswerModel class],@"rela":[RelaQuestModel class]};
}


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end


@implementation GroupDataModel
//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    GroupDataModel *groupModel = [[GroupDataModel allocWithZone:zone] init];
   
    NSMutableArray* arr = [NSMutableArray array];
    for (QuestionModel* temp in _groupDatas) {
        [arr addObject:[temp copy]];
    }
    groupModel.groupDatas = [arr copy];
    groupModel.groupID = [_groupID copy];
    groupModel.groupName = [_groupName copy];
    groupModel.groupSeq = _groupSeq;
    groupModel.groupType = _groupType;
    groupModel.groupShowStyle = _groupShowStyle;
    groupModel.groupCode = [_groupCode copy];
    groupModel.groupPC = _groupPC;
    groupModel.relaNum = _relaNum;
    
    return groupModel;
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"groupDatas":[QuestionModel class]};
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end


@implementation QuestionnaireModel


#pragma mark - 处理
+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"QNData":[GroupDataModel class]};
}


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}
//解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
