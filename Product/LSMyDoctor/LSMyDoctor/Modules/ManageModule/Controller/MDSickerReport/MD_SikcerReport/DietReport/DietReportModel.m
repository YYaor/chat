//
//  DietReportModel.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/1.
//
//

#import "DietReportModel.h"

@implementation DietReportModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [DietReportDataModel class]};
}
@end

@implementation DietReportDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"groups": [DietGroupModel class]};
}

@end


@implementation DietGroupModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"items":[DRGItemModel class]};
}

@end

@implementation DRGItemModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [DRGDataModel class], @"caption" : [DRGCaptionModel class]};
}

@end

@implementation DRGCaptionModel

@end

@implementation DRGDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"list" : [ListT06T05Model class]};
}

@end

@implementation ListT06T05Model

@end