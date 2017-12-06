//
//  MDEditMyAdviceVC.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditBlock)(NSString* value);//点击回调

@interface MDEditMyAdviceVC : UIViewController

@property (nonatomic , assign) NSInteger index;
@property (nonatomic , strong) NSString* haveStr;//已经提交过的值
@property (nonatomic , strong)EditBlock submitBlock;

@end
