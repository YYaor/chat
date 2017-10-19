//
//  LSPatientListCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/9.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSPatientListCell.h"

@interface LSPatientListCell ()

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UIButton *chooseButton;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)UILabel *goodLabel;

@property (nonatomic,strong)UIImageView *moreImageView;

@end

@implementation LSPatientListCell

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
    [self.contentView addSubview:self.chooseButton];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.goodLabel];
    [self.contentView addSubview:self.moreImageView];
    
    self.chooseButton.userInteractionEnabled = NO;
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.chooseButton.mas_right).offset(15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self.headImageView.mas_top).offset(5);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 19));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-14);
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseButton.mas_left);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

-(void)setModel:(LSPatientModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.infoLabel.text = [NSString stringWithFormat:@"%@   %@",model.sex,model.age];
    self.chooseButton.selected = model.isChoosed;
    if (model.goodAt) {
        self.goodLabel.text = model.goodAt;
        
    }
}

-(void)setHideChoosed:(BOOL)hideChoosed{
    _hideChoosed = hideChoosed;
    if (hideChoosed) {
        self.moreImageView.hidden = NO;
        self.chooseButton.hidden = YES;
        [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(14);
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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

-(UIImageView *)moreImageView{
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc]init];
        _moreImageView.image = [UIImage imageNamed:@"right_white_Public"];
        _moreImageView.hidden = YES;
    }
    return _moreImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorFromHexString:@"333333"];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLabel;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor colorFromHexString:@"333333"];
        _infoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _infoLabel;
}

-(UILabel *)goodLabel{
    if (!_goodLabel) {
        _goodLabel = [[UILabel alloc]init];
        _goodLabel.textColor = [UIColor colorFromHexString:@"bfbfbf"];
        _goodLabel.font = [UIFont systemFontOfSize:15];
        _goodLabel.numberOfLines = 1;
    }
    return _goodLabel;
}

-(UIButton *)chooseButton{
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc]init];
        [_chooseButton setImage:[UIImage imageNamed:@"selectedBox_Public"] forState:UIControlStateSelected];
        [_chooseButton setImage:[UIImage imageNamed:@"unSelectBox_Public"] forState:UIControlStateNormal];
    }
    return _chooseButton;
}


@end
