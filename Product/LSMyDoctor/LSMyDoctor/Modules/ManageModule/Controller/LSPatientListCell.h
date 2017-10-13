//
//  LSPatientListCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/9.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPatientModel.h"

@interface LSPatientListCell : UITableViewCell

@property (nonatomic,strong)LSPatientModel *model;

@property (nonatomic,assign)BOOL hideChoosed;

@end
