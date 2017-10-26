//
//  MDChooseSickerCell.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 17/10/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDChooseSickerCell : UITableViewCell

@property (nonatomic , assign) BOOL isSelected;
@property (nonatomic , strong) NSString* imgUrl;
@property (nonatomic , strong) NSString* userNameStr;//姓名
@property (nonatomic , strong) NSString* sexAndAgeStr;
@property (nonatomic , assign) BOOL isImportant;

@end
