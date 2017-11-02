//
//  BalanceModel.h
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BalanceData,BalanceGroups,BalanceItems,BalanceInData, BalanceList;
@interface BalanceModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) BalanceData *data;

@end
@interface BalanceData : NSObject<YYModel>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *header;

@property (nonatomic, assign) BOOL horizontal;

@property (nonatomic, strong) NSArray<BalanceGroups *> *groups;

@end

@interface BalanceGroups : NSObject<YYModel>

@property (nonatomic, strong) NSArray<BalanceItems *> *items;

@property (nonatomic, assign) NSInteger background;

@end

@interface BalanceItems : NSObject<YYModel>

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) BalanceInData *data;

@end

@interface BalanceInData : NSObject<YYModel>

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) NSInteger color;

@property (nonatomic, strong) NSArray * list;

@end


