//
//  LSAddDocCollectionCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSPatientModel.h"

@interface LSAddDocCollectionCell : UICollectionViewCell

@property (nonatomic,strong)LSPatientModel *model;

@property (nonatomic,copy)void (^clodeBlock)(LSPatientModel *model);

@end
