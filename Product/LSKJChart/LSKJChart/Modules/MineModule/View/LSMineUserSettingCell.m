//
//  LSMineUserSettingCell.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineUserSettingCell.h"

@interface LSMineUserSettingCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UIImageView *moreImageView;

@end

@implementation LSMineUserSettingCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.moreImageView];
    [self.contentView addSubview:self.headImageView];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.equalTo(self.moreImageView.mas_left).offset(-5);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.moreImageView.mas_left).offset(-5);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(20);
    }];
    
    [self.infoLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorFromHexString:@"dedede"];
    [self.contentView addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

-(void)updateTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)updateHead:(NSString *)headURL{
    
}

-(void)updateName:(NSString *)name{
    self.infoLabel.text = name;
}

-(void)updateHospital:(NSString *)hospital{
    self.infoLabel.text = hospital;
}

-(void)updateRoom:(NSString *)room{
    self.infoLabel.text = room;
}

-(void)updateCareer:(NSString *)career{
    self.infoLabel.text = career;
}

-(void)updateGoodat:(NSString *)goodat{
    self.infoLabel.text = goodat;
}

-(void)updateInfo:(NSString *)info{
    self.infoLabel.text = info;
}

-(void)hideHeadImageView:(BOOL)hide{
    self.headImageView.hidden = hide;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorFromHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor colorFromHexString:@"bfbfbf"];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.numberOfLines = 2;
    }
    return _infoLabel;
}

-(UIImageView *)moreImageView{
    if(!_moreImageView){
        _moreImageView = [[UIImageView alloc]init];
        _moreImageView.image = [UIImage imageNamed:@"back_g"];
    }
    return _moreImageView;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor redColor];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 30;
    }
    return _headImageView;
}

@end
