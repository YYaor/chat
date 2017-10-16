//
//  MDPeerDetailVC.h
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPeerDetailVC : UIViewController
/**
 *  医生ID
 ***/
@property (nonatomic ,strong)NSString* doctorIdStr;
/**
 *  是否为好友
 ***/
@property (nonatomic ,assign)BOOL isFriend;

@end
