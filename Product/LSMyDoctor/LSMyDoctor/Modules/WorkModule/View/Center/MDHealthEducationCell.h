//
//  MDHealthEducationCell.h
//  LSMyDoctor
//
//  Created by WangQuanjiang on 2017/11/22.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHealthEducationCell : UITableViewCell

@property (nonatomic , strong)NSString* titleStr;//标题
@property (nonatomic , strong)NSString* signUpNumStr;//已报名人数
@property (nonatomic , strong)NSString* totalNumStr;//总报名人数

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;


@end
