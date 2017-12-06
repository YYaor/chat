//
//  MDSingleCommunicationVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/17.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface MDSingleCommunicationVC : EaseMessageViewController<EaseChatBarMoreViewDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>
/**
 *  用户姓名
 **/
@property (nonatomic ,strong)NSString* titleStr;
/**
 *  用户id
 *  用于跳转至对应详情
 **/
@property (nonatomic ,strong)NSString* user_idStr;

@end
