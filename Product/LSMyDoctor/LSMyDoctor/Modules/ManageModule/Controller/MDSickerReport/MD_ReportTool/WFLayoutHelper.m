//
//  WFLayoutHelper.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/12.
//
//

#import "WFLayoutHelper.h"

@implementation WFLayoutHelper

- (instancetype)initWithFilePath:(NSString *) filePath{
    
    if (self = [super init]) {
        _LayoutModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    return self;
}

#pragma mark - 帮助方法
- (AppLayoutModel *)getAppLayoutModel{
    
    return self.LayoutModel;
}

- (NSArray *)getSubLayouts{
    
    if (self.LayoutModel) {
        ModulesModel *modules = self.LayoutModel.modules;
        return modules.data;
        
    }else{
        NSLog(@"首页模块解析出错");
        return nil;
    }
    
}

- (NSInteger)getQNIdByModuleId:(NSInteger) moduleId{
    for (QuestionnaireInfoModel *questInfo in self.LayoutModel.questionnaire) {
        if (questInfo.ModuleID == moduleId) {
            return questInfo.QNId;
        }
    }
    return -1;
}
- (NSInteger)getQNIdByQNName:(NSString *) qnName ModuleId:(NSInteger) moduleId{
    
    for (QuestionnaireInfoModel *questInfo in self.LayoutModel.questionnaire) {
        if (questInfo.ModuleID == moduleId && [questInfo.QNName isEqualToString:qnName]) {
            

            return questInfo.QNId;
        }
    }
    return -1;
}

- (NSInteger)getLayoutVersion{
    
    if(!self.LayoutModel) {
        //无本地数据返回0
        return 0;
        //
    }else{
        //返回本地的版本号
        return [self.LayoutModel.latestNo integerValue];
    }
}

- (NSInteger)getQNCode{
    
    if (self.LayoutModel) {
        NSArray *questInfoArr = self.LayoutModel.questionnaire;
        for (QuestionnaireInfoModel *model in questInfoArr) {
            if (model.ModuleID == 104) {
//                return model.QNCode;
                return model.QNId;
            }
        }
    }
    return 0;
}


#pragma mark - 图文混排:富文本显示文字和图片
+ (NSAttributedString *) mixImage:(UIImage *) image text:(NSString *) text fontSize:(CGFloat) fontSize{
    
    //将图片转换成文本附件
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    
    //将文本附件转换成富文本
    NSAttributedString *imageAttri = [NSAttributedString attributedStringWithAttachment:imageMent];
    
    //将文字转换成富文本
    NSAttributedString *textAttri = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    ",text] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName : RGBCOLOR(232, 102, 64)}];
    
    //将文字富文本和图片富文本拼接起来
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]init];
    [attriStr appendAttributedString:textAttri];
    [attriStr appendAttributedString:imageAttri];
    
    //返回富文本
    return attriStr;
}

#pragma mark - 图文混排:富文本显示文字和图片
+ (NSAttributedString *) mixImageFront:(UIImage *) image textBack:(NSString *) text{
    
    //将图片转换成文本附件
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    
    //将文本附件转换成富文本
    NSAttributedString *imageAttri = [NSAttributedString attributedStringWithAttachment:imageMent];
    
    //将文字转换成富文本
    NSAttributedString *textAttri = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",text] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : UIColorHex(@"212121")}];
    
    //将文字富文本和图片富文本拼接起来
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]init];
    [attriStr appendAttributedString:imageAttri];
    [attriStr appendAttributedString:textAttri];
    
    //返回富文本
    return attriStr;
}

+ (NSAttributedString *) mixImageFront:(UIImage *) image textBack:(NSString *) text font:(CGFloat) font{
    
    //将图片转换成文本附件
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    
    //将文本附件转换成富文本
    NSAttributedString *imageAttri = [NSAttributedString attributedStringWithAttachment:imageMent];
    
    //将文字转换成富文本
    NSAttributedString *textAttri = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",text] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font],NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    
    //将文字富文本和图片富文本拼接起来
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]init];
    [attriStr appendAttributedString:imageAttri];
    [attriStr appendAttributedString:textAttri];
    
    //返回富文本
    return attriStr;
}
//记录模块访问日志
+ (void)recordModuleAskLogWithModuleId:(NSString *) moduleId ModuleName:(NSString *)moduleName{
    
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    if (TARGET_IPHONE_SIMULATOR) {
//        [param setValue:@"000f6e53c58476069be11074a8e6e19d29b62e4a65187451c64cff2458d08d21" forKey:@"deviceToken"];
//    }else{
//        UserBaseInfo *userInfo = [UserBaseInfo sharedBaseInfo];
//        [param setValue:userInfo.deviceToken forKey:@"deviceToken"];
//    }
//    [param setValue:@0 forKey:@"deviceType"];
//    [param setValue:moduleId forKey:@"moduleId"];
//    [param setValue:moduleName forKey:@"moduleName"];
//    [param setValue:[Defaults valueForKey:@"userKey"] forKey:@"userKey"];
//    [param setValue:AccessToken forKey:@"accessToken"];
//    
//    [[TLAsiNetworkHandler sharedInstance] requestURL:PATH(@"%@/accessLog/noteModuleAccessLog") networkType:TLAsiNetWorkPOST params:param delegate:nil showHUD:YES successBlock:^(NSDictionary *returnData) {
//        
//        if (returnData && [returnData[@"status"] integerValue] == 0) {
//            NSLog(@"====记录模块访问日志成功====");
//        }else{
//            NSLog(@"====记录模块访问日志失败====");
//        }
//        
//    } failureBlock:^(id error) {
//        NSLog(@"====记录模块访问日志失败====");
//    }];
}

#pragma mark - GroupDataModel至少填写一题
+ (void)clearAnswerWithGroupDataModel:(GroupDataModel *) groupModel{
    
    for (QuestionModel *model in groupModel.groupDatas) {
        
        for (AnswerModel *answer in model.anInfo) {
            
            if (model.anInfo && (model.type == 1 || model.type == 2 || model.type == 3 || model.type == 9)) {
                
                if (answer.isSelected) {
                    
                    answer.isSelected = NO;
                }
            }else if (model.anInfo && (model.type == 8 || model.type == 10)) {
                
                if (answer.SaveValue && answer.SaveValue.length > 0) {
                    
                    answer.SaveValue = nil;
                }
            }else{
                
                if (model.resultStr && model.resultStr.length > 0) {
                    model.resultStr = nil;
                }
            }
        }
    }
}

#pragma mark - GroupDataModel至少填写一题
+ (BOOL)isHasRecordWithGroupDataModel:(GroupDataModel *) groupModel{
    
    BOOL isDoneQuestNaire = NO;//问卷至少填写一题
    
    for (QuestionModel *model in groupModel.groupDatas) {
        model.isSaveFlag = NO;//保存标记
        model.isRequired = NO;//必填未填写
        for (AnswerModel *answer in model.anInfo) {
            
            NSLog(@"%@",answer.isSelected?@"选中":@"非选中");
            
            if (model.anInfo && (model.type == 1 || model.type == 2 || model.type == 3 || model.type == 9)) {
                
                if (answer.isSelected) {
                    
                    isDoneQuestNaire = YES;
                }
            }else if (model.anInfo && (model.type == 8 || model.type == 10)) {
                
                if (answer.SaveValue && answer.SaveValue.length > 0) {
                    
                    isDoneQuestNaire = YES;
                }
            }else{
                
                if (model.resultStr && model.resultStr.length > 0) {
                    
                    isDoneQuestNaire = YES;
                }
            }
        }
    }
    return isDoneQuestNaire;
}

#pragma mark - 请选择必选题:YES -- 已填写,NO -- 未填写
+ (BOOL)isDoReqiureQuestionOfGroupModel:(GroupDataModel *) groupModel{
    
    BOOL hasRequired = NO;//必选题是否已做
    
    for (QuestionModel *model in groupModel.groupDatas) {
        
        model.isSaveFlag = YES;//保存标记
        if (model.required) {
            for (AnswerModel *answer in model.anInfo) {
                if (model.anInfo && (model.type == 1 || model.type == 2 || model.type == 3 || model.type == 9)) {
                    
                    if (answer.isSelected) {
                        hasRequired = YES;
                        model.isRequired = YES;
                    }
                    
                }else if (model.anInfo && (model.type == 8 || model.type == 10)) {
                    
                    if (answer.SaveValue && answer.SaveValue.length > 0) {
                        hasRequired = YES;
                        model.isRequired = YES;
                        
                    }
                }else{
                    if (model.resultStr && model.resultStr.length > 0) {
                        hasRequired = YES;
                        model.isRequired = YES;
                    }
                }
            }
        }
    }
    
    
    BOOL isRequired = NO;

    for (QuestionModel *model in groupModel.groupDatas) {
        
        if (model.required && !model.isRequired) {
            
            isRequired = YES;
        }
    }

    if (isRequired) {
        //未填写必选题
        return NO;
    }else{
        //已填写必选题
        return YES;
    }
}

#pragma mark - 第一个必选题的位置
+ (NSIndexPath *)getFirRequiredQNOfGroupModel:(GroupDataModel *) groupModel{
    
    BOOL hasRequired = NO;//必选题是否已做
    
    for (QuestionModel *model in groupModel.groupDatas) {
        
        model.isSaveFlag = YES;//保存标记
        if (model.required) {
            for (AnswerModel *answer in model.anInfo) {
                if (model.anInfo && (model.type == 1 || model.type == 2 || model.type == 3 || model.type == 9)) {
                    
                    if (answer.isSelected) {
                        hasRequired = YES;
                        model.isRequired = YES;
                    }
                    
                }else if (model.anInfo && (model.type == 8 || model.type == 10)) {
                    
                    if (answer.SaveValue && answer.SaveValue.length > 0) {
                        hasRequired = YES;
                        model.isRequired = YES;
                        
                    }
                }else{
                    if (model.resultStr && model.resultStr.length > 0) {
                        hasRequired = YES;
                        model.isRequired = YES;
                    }
                }
            }
        }
    }
    
    
    NSIndexPath *indexPath = nil;
    
    for (int j = 0; j < groupModel.groupDatas.count; ++j) {
        QuestionModel *model = groupModel.groupDatas[j];
        
        if (model.required && !model.isRequired) {
            
            indexPath = [NSIndexPath indexPathForRow:j inSection:0];
            return indexPath;
        }
    }
    
    return indexPath;

}

@end
