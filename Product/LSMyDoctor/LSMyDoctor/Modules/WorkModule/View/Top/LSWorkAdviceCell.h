//
//  LSWorkAdviceCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/28.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWorkAdviceCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dataDic;

@property (nonatomic, copy) void (^agreeClickBlock)(NSDictionary *dataDic) ;


@end
