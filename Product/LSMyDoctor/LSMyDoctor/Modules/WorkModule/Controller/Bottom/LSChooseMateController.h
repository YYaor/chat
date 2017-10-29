//
//  LSChooseMateController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/13.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDGroupDetailModel.h"

@interface LSChooseMateController : UIViewController

@property (nonatomic,copy)void (^chooseBlock)(NSArray *modelArray);

//当作为修改群组成员时
@property (nonatomic , assign) BOOL submitData;//是否需要提交数据 若为YES，没有返回数据。
@property (nonatomic , strong) MDGroupDetailModel* groupDetailModel;//修改成员时，已有成员模型。
@property (nonatomic , strong) NSString* groupIdStr;//组id

@end
