//
//  MDDataStatisticsModel.h
//  MyDoctor
//
//  Created by 惠生 on 17/8/3.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDataStatisticsModel : NSObject<YYModel>

@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* total;
@property (nonatomic,strong)NSString* year_sum;
@property (nonatomic,strong)NSString* month_sum;
@property (nonatomic,strong)NSString* year_total;
@property (nonatomic,strong)NSString* month_total;

@end
