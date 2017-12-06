//
//  LSWorkActivityCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/21.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWorkActivityCell : UITableViewCell

@property (nonatomic, copy) void (^deleteBlock)(NSDictionary *dataDic);

- (void)setDataWithDictionary:(NSDictionary *)dic;

@end
