//
//  DietModel.h
//  YouGeHealth
//
//  Created by yunzujia on 16/10/17.
//
//

#import <Foundation/Foundation.h>


@class DataoutModel,ContentModel,SelectedfoodlistModel,DatainModel,EattypelistModel,UnitlistModel,FoodtypelistModel,LabelModel;
@interface DietModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString * userKey;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) DataoutModel *data;




@end


@interface DataoutModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString * userKey;

@property (nonatomic, strong) NSArray<FoodtypelistModel *> *foodTypeList;

@property (nonatomic, strong) ContentModel *content;

@property (nonatomic, strong) NSArray<EattypelistModel *> *eatTypeList;

@property (nonatomic, copy) NSString *isHaveCollection;

@end

@interface ContentModel : NSObject<YYModel, NSCoding>

@property (nonatomic, strong) NSArray<SelectedfoodlistModel *> *selectedFoodList;

@property (nonatomic, copy) NSString *yougeFoodMark;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, copy) NSString *needToEat;

@property (nonatomic, copy) NSString *date;

@end

@interface SelectedfoodlistModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString *eatTypeName;

@property (nonatomic, strong) NSArray<DatainModel *> *data;

@property (nonatomic, assign) NSInteger eatTypeID;

@end

@interface DatainModel : NSObject<YYModel, NSCoding>

@property (nonatomic, assign) NSInteger unitQty;

@property (nonatomic, assign) BOOL isShow;//解释内容是否已显示,

@property (nonatomic, copy) NSString *unitName;

@property (nonatomic, assign) NSInteger foodID;

@property (nonatomic, copy) NSString *foodCode;

@property (nonatomic, copy) NSString * eatTypeID;

@property (nonatomic, assign) NSInteger orderID;

@property (nonatomic, strong) NSArray<UnitlistModel *> *unitList;

@property (nonatomic, copy) NSString * explain;

@property (nonatomic, copy) NSString *foodName;

@property (nonatomic, copy) NSString *foodCurrent;

@property (nonatomic, assign) NSInteger selectID;

@property (nonatomic, assign) NSInteger quantity;

@property (nonatomic, strong) NSArray<EattypelistModel *> *eatTypeList;

@property (nonatomic, copy) NSString *foodFirstName;

@property (nonatomic, copy) NSString *foodRemark;

@property (nonatomic, copy) NSString *foodRename;

@property (nonatomic, assign) NSInteger foodTypeID;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, assign) NSInteger isEnable;

@property (nonatomic, assign) NSInteger unitID;

@property (nonatomic, assign) NSInteger isRecommend;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *calory;

@property (nonatomic, assign) NSInteger isCollected;//是否收藏

@property (nonatomic, copy) NSString *labelID;

@property (nonatomic, assign) NSInteger collectionID;

@property (nonatomic, assign) NSInteger labelType;//显示大拇指还是显示标签，就由它来确定了。标签类型(0,不显示，1, 大拇指 2,标签 )
@property (nonatomic, strong) LabelModel * labels;//该模型在foodlistmodel中

@end

@interface EattypelistModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString *eatTypeName;

@property (nonatomic, assign) NSInteger orderID;

@property (nonatomic, assign) NSInteger eatTypeID;

@property (nonatomic, assign) NSInteger qncode;//口味对应问卷id

@end

@interface UnitlistModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString *unitName;

@property (nonatomic, assign) NSInteger unitQty;

@property (nonatomic, assign) NSInteger foodID;

@property (nonatomic, assign) NSInteger orderID;

@property (nonatomic, assign) NSInteger unitID;

@property (nonatomic, copy) NSString *unitRemark;

@end



@interface FoodtypelistModel : NSObject<YYModel, NSCoding>

@property (nonatomic, copy) NSString *foodTypeName;

@property (nonatomic, assign) NSInteger orderID;

@property (nonatomic, assign) NSInteger foodTypeID;

@end

