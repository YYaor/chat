//
//  MDSingleCommunicationVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/17.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface MDSingleCommunicationVC : EaseMessageViewController<EaseChatBarMoreViewDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@property (nonatomic ,strong)NSString* user_idStr;

@end
