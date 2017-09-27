//
//  LSMineUserSettingCell.h
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSUserModel.h"
@interface LSMineUserSettingCell : UITableViewCell

@property (nonatomic,strong)LSUserModel *user;

-(void)hideHeadImageView:(BOOL)hide;

-(void)updateTitle:(NSString *)title;

-(void)updateHead:(NSString *)headURL;

-(void)updateName:(NSString *)name;

-(void)updateHospital:(NSString *)hospital;

-(void)updateRoom:(NSString *)room;

-(void)updateCareer:(NSString *)career;

-(void)updateGoodat:(NSString *)goodat;

-(void)updateInfo:(NSString *)info;

@end
