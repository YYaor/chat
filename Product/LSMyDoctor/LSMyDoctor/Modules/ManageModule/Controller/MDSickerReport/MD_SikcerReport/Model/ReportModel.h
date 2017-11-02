//
//  ReportModel.h
//  YouGeHealth
//
//  Created by earlyfly on 16/10/17.
//
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class ReportItemModel;

@interface LegendModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger coordinate;//坐标点

@property (nonatomic,assign) NSInteger color;
@property (nonatomic,copy) NSString *label;

@property (nonatomic,assign) NSInteger x;
@property (nonatomic,assign) NSInteger y;

@end

@interface ReportItemDataModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger onion;//洋葱头等级
@property (nonatomic,assign) NSInteger light;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSArray *list;
@property (nonatomic,assign) NSInteger colNum;
@property (nonatomic,assign) BOOL drag;
@property (nonatomic,copy) NSArray *names;
//T08
@property (nonatomic,copy)NSString *buttonText;//按钮文字

@property (nonatomic,assign) BOOL showValue;//T02
//T13
@property (nonatomic,copy) NSArray *good;
@property (nonatomic,copy) NSArray *bad;
//T14
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger color;
//T15、T18
@property (nonatomic,copy)NSString *ylabel;
@property (nonatomic,assign) NSInteger ymax;
@property (nonatomic,assign) NSInteger xmax;
@property (nonatomic,copy) NSArray *data;//LegendModel
@property (nonatomic,copy) NSArray *ordinate;//纵坐标上的值LegendModel
@property (nonatomic,copy) NSArray *legend;//LegendModel
@property (nonatomic,copy) NSString *xlabel;
@property (nonatomic,assign) NSInteger Ox;
@property (nonatomic,assign) NSInteger Oy;
@property (nonatomic,strong) ReportItemModel *detail;//ReportItemModel
@property (nonatomic,copy) NSArray *abscissa;//横坐标上的值LegendModel

//T19
@property (nonatomic,copy) NSArray *hi_data;//LegendModel
@property (nonatomic,copy) NSArray *lo_data;//LegendModel
@property (nonatomic,assign) NSInteger hi_std_max;//标准区间最大值
@property (nonatomic,assign) NSInteger hi_std_min;//标准区间最大值
@property (nonatomic,assign) NSInteger lo_std_max;//标准区间最大值
@property (nonatomic,assign) NSInteger lo_std_min;//标准区间最大值

@property (nonatomic,copy) NSString *notes;//T26
@property (nonatomic,copy) NSString *label;//T26
@property (nonatomic,copy) NSString *value;//T26

@property (nonatomic,assign) NSInteger max;//T04
@property (nonatomic,copy) NSString *unit;//T04

@property (nonatomic,copy) NSString *ending;//T27
@property (nonatomic,copy) NSString *message;//T27

@property (nonatomic,assign) NSInteger std_max;//标准区间最大值
@property (nonatomic,assign) NSInteger std_min;//标准区间最小值

@property (nonatomic,copy) NSString *left_name;//T22
@property (nonatomic,copy) NSString *left_value;//T22
@property (nonatomic,copy) NSString *left_unit;//T22
@property (nonatomic,copy) NSString *right_name;//T22
@property (nonatomic,copy) NSString *right_value;//T22
@property (nonatomic,copy) NSString *right_unit;//T22


@property (nonatomic,copy) NSString *T28_head;//T28
@property (nonatomic,copy) NSArray *T28_body;//T28
@property (nonatomic,copy) NSString *T28_foot;//T28
@property (nonatomic,assign) NSInteger T28_onion;//洋葱头等级


@property (nonatomic,copy) NSString *text;//T30


@property (nonatomic,assign) BOOL isNormal;//T31
@property (nonatomic,copy) NSString *referenceValue;//T31

@property (nonatomic,copy) NSString *ReplaceTitle;//T33


@end

@interface ReportCaptionModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL left;

@end

@interface ReportItemModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) ReportItemDataModel *data;
@property (nonatomic,strong) ReportCaptionModel *caption;

@end

@interface ReportControlModel : NSObject<YYModel>

@property (nonatomic,assign) BOOL collapse;
@property (nonatomic,assign) BOOL fold;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *text;

@end

@interface ReportGroupModel : NSObject<YYModel>

@property (nonatomic,assign) NSInteger background;//分组背景色
@property (nonatomic,copy) NSArray *items;//ReportItemModel
@property (nonatomic,strong) ReportControlModel *controll;

@end

@interface ReportModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *horizontal;
@property (nonatomic, assign) NSInteger IsSimple;//是否为生活日记简版报告
//@property (nonatomic,copy) NSString *image;
//@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *title;
//@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSArray *groups;//ReportGroupModel

@end
