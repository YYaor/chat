//
//  MDSingleCommunicateVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/18.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface MDSingleCommunicateVC : EaseMessageViewController<EaseMessageViewControllerDelegate , EaseMessageViewControllerDataSource>

@property (nonatomic ,strong) NSString* titleNameStr;

@end
