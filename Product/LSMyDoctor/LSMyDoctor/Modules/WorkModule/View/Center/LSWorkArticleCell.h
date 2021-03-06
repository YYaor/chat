//
//  LSWorkArticleCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/8.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSWorkArticleCell : UITableViewCell

@property (nonatomic, copy) void (^deleteBlock)(NSDictionary *dataDic) ;

- (void)setDataWithDictionary:(NSDictionary *)data type:(NSString *)type;

@end
