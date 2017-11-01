//
//  MDAddGroupVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/30.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSickerGroupDetailModel.h"

@interface MDAddGroupVC : UIViewController

@property (nonatomic , assign) BOOL submitData;//是否需要提交数据 若为YES，没有返回数据。
@property (nonatomic , strong) MDSickerGroupDetailModel* groupDetailModel;//修改成员时，已有成员模型。
@property (nonatomic , strong) NSString* groupIdStr;//组id

@end
