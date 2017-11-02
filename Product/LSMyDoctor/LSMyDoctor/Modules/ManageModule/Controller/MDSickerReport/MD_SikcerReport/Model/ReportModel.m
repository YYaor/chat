//
//  ReportModel.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/17.
//
//

#import "ReportModel.h"

@implementation LegendModel

@end

@implementation ReportItemDataModel

@end

@implementation ReportCaptionModel : NSObject

@end

@implementation ReportItemModel


@end

@implementation ReportControlModel


@end

@implementation ReportGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将属性的数组元素，变成对象数组
    return @{@"items":[ReportItemModel class]};
}

@end

@implementation ReportModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将属性的数组元素，变成对象数组
    return @{@"groups":[ReportGroupModel class]};
}

@end
