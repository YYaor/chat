//
//  MDChooseSickerVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDChooseSickerVC : UIViewController


@property (nonatomic,copy)void (^chooseBlock)(NSMutableArray *modelArray);

@end
