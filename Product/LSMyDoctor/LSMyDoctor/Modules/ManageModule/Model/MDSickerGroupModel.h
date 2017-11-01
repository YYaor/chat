//
//  MDSickerGroupModel.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSickerGroupModel : NSObject

@property (nonatomic, copy) NSString *doctor_id;//群主iD
@property (nonatomic, copy) NSString *groupId;//群ID
@property (nonatomic, copy) NSString *im_groupid;//IM聊天群ID
@property (nonatomic, copy) NSString *img_url;//群头像
@property (nonatomic, copy) NSString *is_stick;//是否置顶
@property (nonatomic, copy) NSString *name;//群名称

@property (nonatomic, assign) BOOL isSelected;//是否选中


@end
