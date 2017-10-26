//
//  MDChooseSickerModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDChooseSickerModel : NSObject<YYModel>

@property (nonatomic , strong) NSString* birthday;
@property (nonatomic , strong) NSString* sex;
@property (nonatomic , strong) NSString* username;
@property (nonatomic , strong) NSString* is_focus;
@property (nonatomic , strong) NSString* user_id;

@property (nonatomic , assign) BOOL is_Selected;

@end
