//
//  DietReportModel.h
//  YouGeHealth
//
//  Created by yunzujia on 16/11/1.
//
//

#import <Foundation/Foundation.h>

@class DRGDataModel,DietReportDataModel,DietGroupModel,DRGItemModel,ListT06T05Model,DRGCaptionModel,DRGDataModel;

@interface DietReportModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger            status;
@property (nonatomic, strong) DietReportDataModel *data;

@end


@interface DietReportDataModel : NSObject<YYModel>  //报告最外层data

@property (nonatomic, copy  ) NSString       *header;
@property (nonatomic, assign) NSInteger       horizontal;
@property (nonatomic, assign) NSInteger       IsSimple;//是否为生活日记简版报告
@property (nonatomic, copy  ) NSString       *title;
@property (nonatomic, strong) NSArray <DietGroupModel *> *groups;

@end

@interface DietGroupModel : NSObject<YYModel>   //一个group

@property (nonatomic, assign) NSInteger                 background;
@property (nonatomic, strong) NSArray <DRGItemModel *> *items;
//@property (nonatomic, copy  ) NSString                 *type;

@end

@interface DRGItemModel : NSObject<YYModel>//一个item

@property (nonatomic, strong) DRGDataModel * data;
@property (nonatomic, copy  ) NSString * type;             //T05类型id
@property (nonatomic, strong) DRGCaptionModel * caption;   //T05,T06特有

@end

@interface DRGCaptionModel : NSObject<YYModel>//T05,T06特有
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, copy) NSString * text;
@end

@interface DRGDataModel : NSObject<YYModel>//里层的data

//type ＝ T22特有
@property (nonatomic, copy) NSString * left_name;
@property (nonatomic, copy) NSString * left_unit;
@property (nonatomic, assign) NSInteger left_value;
@property (nonatomic, copy) NSString * right_name;
@property (nonatomic, copy) NSString * right_unit;
@property (nonatomic, assign) NSInteger right_value;

//type ＝ T106,T06特有
@property (nonatomic, strong) NSArray<ListT06T05Model *>* list;

//type = T05特有
@property (nonatomic, assign) NSInteger max;

@end


@interface ListT06T05Model : NSObject<YYModel>

//type = T05,T06公有
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger value;

//type = T06特有
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger std_max;
@property (nonatomic, assign) NSInteger std_min;
@property (nonatomic, copy) NSString * unit;

//type = T05特有
@property (nonatomic, assign) NSInteger std;

@end






