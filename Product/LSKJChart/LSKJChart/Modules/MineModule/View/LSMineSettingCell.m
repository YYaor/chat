//
//  LSMineSettingCell.m
//  LSKJChart
//
//  Created by 刘博宇 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineSettingCell.h"

@interface LSMineSettingCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)UIImageView *moreImageView;

@end

@implementation LSMineSettingCell

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
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.moreImageView.mas_left).offset(-5);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(20);
    }];
    
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

-(void)updateCell:(NSString *)title info:(NSString *)info{
    self.titleLabel.text = title;
    self.infoLabel.text = info;
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

@end
