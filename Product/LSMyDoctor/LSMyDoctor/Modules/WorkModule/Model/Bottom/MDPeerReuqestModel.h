//
//  MDPeerReuqestModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/19.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDPeerReuqestModel : NSObject<YYModel>

@property (nonatomic ,strong) NSString* pageNumber;
@property (nonatomic ,strong) NSString* totalPages;
@property (nonatomic ,strong) NSString* pageSize;
@property (nonatomic ,strong) NSString* total;
@property (nonatomic ,strong) NSArray* content;

@end



@interface MDRequestContentModel : NSObject<YYModel>

@property (nonatomic ,strong) NSString* requestId;
@property (nonatomic ,strong) NSString* remark;
@property (nonatomic ,strong) NSString* result;
@property (nonatomic ,strong) NSString* username;

@end


