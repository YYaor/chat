//
//  MDActivityStatisticsModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/22.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDActivityStatisticsModel : NSObject<YYModel>

@property (nonatomic,strong)NSString* activity_id;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* sign_number;
@property (nonatomic,strong)NSString* total_number;

@end
