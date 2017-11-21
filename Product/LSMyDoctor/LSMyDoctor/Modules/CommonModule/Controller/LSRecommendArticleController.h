//
//  LSRecommendArticleController.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/15.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSRecommendArticleController : UIViewController

@property (nonatomic, copy) void (^sureBlock)(NSDictionary *dataDic);

@end
