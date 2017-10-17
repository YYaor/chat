//
//  LSAddDocCollectionCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/10/12.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSAddDocCollectionCell.h"

@interface LSAddDocCollectionCell()

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation LSAddDocCollectionCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initForView];
    }
    return self;
}

-(void)initForView{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.nameLabel];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(70);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top).offset(-8);
        make.right.equalTo(self.headImageView.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

-(void)setModel:(LSPatientModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
}

-(void)closeButtonClick{
    if (self.clodeBlock) {
        self.clodeBlock(self.model);
    }
}

-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"del_xRed_Public"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 30;
        _headImageView.backgroundColor = [UIColor redColor];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorFromHexString:@"555555"];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLabel;
}

@end
