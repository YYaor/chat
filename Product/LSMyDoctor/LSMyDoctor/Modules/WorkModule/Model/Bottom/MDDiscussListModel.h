//
//  MDDiscussListModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/20.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDiscussListModel : NSObject<YYModel>

@property (nonatomic , strong) NSString* groupId;
@property (nonatomic , strong) NSString* name;
@property (nonatomic , strong) NSString* doctor_id;
@property (nonatomic , strong) NSString* im_roomid;
@property (nonatomic , strong) NSString* img_url;


@end
