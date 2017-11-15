//
//  MDDataStatisticsModel.h
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDataStatisticsModel : NSObject<YYModel>

@property (nonatomic,strong)NSString* followUp;
@property (nonatomic,strong)NSString* fws;
@property (nonatomic,strong)NSString* signCount;
@property (nonatomic,strong)NSString* visit;

@end
