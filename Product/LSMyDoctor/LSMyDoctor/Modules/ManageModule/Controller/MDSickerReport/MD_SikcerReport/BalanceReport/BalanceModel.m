//
//  BalanceModel.m
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "BalanceModel.h"

@implementation BalanceModel

@end
@implementation BalanceData



+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"groups" : [BalanceGroups class]};
}

@end


@implementation BalanceGroups



+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"items" : [BalanceItems class]};
}

@end


@implementation BalanceItems

@end


@implementation BalanceInData

@end




