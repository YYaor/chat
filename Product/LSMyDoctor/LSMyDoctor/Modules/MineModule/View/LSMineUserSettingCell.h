//
//  LSMineUserSettingCell.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMineUserSettingCell : UITableViewCell

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
