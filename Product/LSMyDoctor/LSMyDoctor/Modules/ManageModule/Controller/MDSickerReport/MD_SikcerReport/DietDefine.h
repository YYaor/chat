//
//  DietDefine.h
//  YouGeHealth
//
//  Created by yunzujia on 16/10/17.
//
//

#ifndef DietDefine_h
#define DietDefine_h
//#define DIET_COMMON                         @"http://192.168.0.137:8080/youge-api/V2.0"

#define DIET_COMMON                         [API_HOST substringToIndex:API_HOST.length - 3]

#define DIET_GETFOODTYPELIST                @"/food/getFoodTypeList"
//食物类别列表
#define DIET_GETCOLLECTIONFOODLIST          @"/food/getCollectionFoodList"
//常用食物列表
#define DIET_GETFOODLIST                    @"/food/getFoodList"

//7天之内是否有添加记录

#define DIET_COPYSTATUS                    @"/food/copyStatus"


#define DIET_SAVECOLLECTION                 @"/food/saveCollection"


//添加食物或者更新食物
#define DIET_SAVEORUPDATEUSERSELECTFOOD     @"/food/saveOrUpdateUserSelectFood"


//取消收藏
#define DIET_CANCELCOLLECTION               @"/food/cancelCollection"


//首页接口
#define DIET_INDEX                          @"/food/index"


#define DIET_DELETSELECTEDFOOD              @"/food/deleteSelectFood"


//搜索接口
#define DIET_GETFOODLISTBYNAME              @"/food/getFoodListByName"

//删除一餐全部
#define DIET_DELETEALLONONEEAT              @"/food/deleteSelectFoodByEatType"


//复制接口
#define DIET_COPYUSERSELECTFOOD            @"/food/copyUserSelectFood"

//口味设置
#define DIET_TASTE                         @"/questions/getQuestionnaire"

#define DIET_REPORT                        @"/report/getReport"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define UIColorFromHex(s)                 [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0green:(((s &0xFF00) >>8))/255.0blue:((s &0xFF))/255.0alpha:1.0]

//判断设备
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6P (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPad ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPadR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define Iphone6ScaleWidth [UIScreen mainScreen].bounds.size.width/375
#define Iphone6ScaleHeight [UIScreen mainScreen].bounds.size.height/667

//今天是否选择过食物
#define DIET_TODAY_ISSELECTFOOD @"DIET_TODAY_ISSELECTFOOD"

#define DIET_COUNT_PATH @"dietcount.data";
#endif /* DietDefine_h */
