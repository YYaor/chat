//
//  MDConsultDiscussCell.h
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDConsultDiscussCell : UITableViewCell

@property (nonatomic ,strong)NSString* imgUrlStr;//组头像
@property (nonatomic ,strong)NSString* groupNameStr;//组名称
@property (nonatomic ,strong)NSString* valueStr;//最新聊天内容
@property (nonatomic ,strong)NSString* timeStr;//最新的聊天时间


@end
