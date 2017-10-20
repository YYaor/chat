//
//  MDPeerReuqestModel.m
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "MDPeerReuqestModel.h"

@implementation MDPeerReuqestModel
//第一级
//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDPeerReuqestModel *peerRequestModel= [[MDPeerReuqestModel allocWithZone:zone] init];
    
    peerRequestModel.pageNumber = [_pageNumber copy];
    peerRequestModel.totalPages = [_totalPages copy];
    peerRequestModel.pageSize = [_pageSize copy];
    peerRequestModel.total = [_total copy];
    
    //请求列表
    NSMutableArray* arr = [NSMutableArray array];
    for (MDRequestContentModel* contentModel in _content) {
        [arr addObject:[contentModel copy]];
    }
    peerRequestModel.content = [arr copy];
    
    return peerRequestModel;
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    //将applications属性的数组元素，变成对象数组
    return @{@"content":[MDRequestContentModel class]};
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


@implementation MDRequestContentModel
//第二级content
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"requestId" : @"id"};
}

//对象拷贝
-(id)copyWithZone:(NSZone*)zone {
    
    MDRequestContentModel *contentModel= [[MDRequestContentModel allocWithZone:zone] init];
    
    contentModel.remark = [_remark copy];
    contentModel.result = [_result copy];
    contentModel.username = [_username copy];
    
    return contentModel;
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


