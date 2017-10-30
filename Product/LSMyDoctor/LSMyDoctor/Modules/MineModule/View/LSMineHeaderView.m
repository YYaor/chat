
//
//  LSMineHeaderView.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/26.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineHeaderView.h"
#import "LSMineUserSettingController.h"

@interface LSMineHeaderView()

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *infoLabel;

@end

@implementation LSMineHeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.infoLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(self).offset(-30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
}

-(void)updateWithImageURL:(NSString *)imageURL name:(NSString *)name career:(NSString *)career{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    self.nameLabel.text = name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@",career];
}

-(void)headClick{
    LSMineUserSettingController *userSettingController = [[LSMineUserSettingController alloc]init];
    userSettingController.model = self.model;
    userSettingController.hidesBottomBarWhenPushed = YES;
    [[self.controller navigationController] pushViewController:userSettingController animated:YES];
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 40;
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick)]];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLabel;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _infoLabel;
}

@end
