//
//  AppLayoutModel.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/8.
//
//

#import "AppLayoutModel.h"

@implementation AppLayoutParamsModel

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


@implementation ModulesModel



+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"appLayoutParams":[AppLayoutParamsModel class],@"data":[ModulesModel class]};
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

@implementation QuestionnaireInfoModel

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

@implementation AppLayoutModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成SubjectAppsModel对象
    return @{@"modules":[ModulesModel class],@"questionnaire":[QuestionnaireInfoModel class]};
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

