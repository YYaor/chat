//
//  MDMyAdviceDetailModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMyAdviceDetailModel : NSObject<YYModel>

@property (nonatomic , copy) NSString* advice;
@property (nonatomic , copy) NSString* diagnosis;
@property (nonatomic , copy) NSString* end_date;
@property (nonatomic , copy) NSString* im_username;
@property (nonatomic , copy) NSString* advice_id;
@property (nonatomic , copy) NSString* pharmacy;
@property (nonatomic , copy) NSString* status;
@property (nonatomic , copy) NSString* visit_date;

@end
