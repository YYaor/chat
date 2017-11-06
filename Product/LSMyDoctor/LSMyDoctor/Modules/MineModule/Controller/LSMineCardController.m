//
//  LSMineCardController.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSMineCardController.h"
#import "SGQRCode.h"
@interface LSMineCardController ()

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UIImageView *qRimageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *roomAndCareerLabel;

@property (nonatomic,strong)UILabel *hospitalLabel;

@property (nonatomic,strong)UILabel *goodatLabel;

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)UILabel *infoLabel1;

@property (nonatomic,strong)UILabel *qRLabel;

@end

@implementation LSMineCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initForView];
}

-(void)initForView{
    
    self.navigationItem.title = @"我的名片";
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.roomAndCareerLabel];
    [self.contentView addSubview:self.hospitalLabel];
    [self.contentView addSubview:self.goodatLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.infoLabel1];
    [self.contentView addSubview:self.qRimageView];
    [self.contentView addSubview:self.qRLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.mas_equalTo(350);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self.headImageView.mas_top).offset(5);
    }];
    
    [self.roomAndCareerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorFromHexString:@"e0e0e0"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.headImageView.mas_bottom).offset(12);
    }];
    
    [self.hospitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.top.equalTo(line).offset(12);
    }];
    
    [self.goodatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.top.equalTo(self.hospitalLabel.mas_bottom).offset(12);
    }];
    
    [self.infoLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_left);
        make.right.equalTo(line.mas_right);
        make.top.equalTo(self.goodatLabel.mas_bottom).offset(12);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_left).offset(74);
        make.right.equalTo(line.mas_right);
        make.top.equalTo(self.goodatLabel.mas_bottom).offset(12);
    }];

    [self.qRimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.qRLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.qRimageView.mas_bottom).offset(15);
    }];
}

-(void)setUserModel:(LSMineModel *)userModel
{
    _userModel = userModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST, userModel.myImage]] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    
    self.nameLabel.text = userModel.myName;
    
    self.roomAndCareerLabel.text = [NSString stringWithFormat:@"%@  %@",userModel.myBaseInfo[3][@"value"],userModel.myBaseInfo[4][@"value"]];
    
    NSString *hosString = [NSString stringWithFormat:@"所在医院   %@",userModel.myBaseInfo[2][@"value"]];
    NSMutableAttributedString *hosAttString = [[NSMutableAttributedString alloc]initWithString:hosString];
    [hosAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"bfbfbf"] range:NSMakeRange(0, 4)];
    self.hospitalLabel.attributedText = hosAttString;
    
    NSString *goodatString = [NSString stringWithFormat:@"擅       长   %@",userModel.myBaseInfo[5][@"value"]];
    NSMutableAttributedString *goodatAttString = [[NSMutableAttributedString alloc]initWithString:goodatString];
    [goodatAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"bfbfbf"] range:NSMakeRange(0, 9)];
    self.goodatLabel.attributedText = goodatAttString;
    
    self.infoLabel.text = userModel.myBaseInfo[6][@"value"];
    
    [self.view layoutIfNeeded];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(self.qRLabel.frame)+40);
    }];
    
    self.qRimageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:userModel.myQR imageViewWidth:self.qRimageView.frame.size.width];
}

-(void)shareButtonClick{
    
}


-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.borderWidth = 1;
        _contentView.layer.borderColor = [UIColor colorFromHexString:@"e0e0e0"].CGColor;
    }
    return _contentView;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 30;
    }
    return _headImageView;
}

-(UIImageView *)qRimageView{
    if (!_qRimageView) {
        _qRimageView = [[UIImageView alloc]init];
        _qRimageView.backgroundColor = [UIColor redColor];
    }
    return _qRimageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

-(UILabel *)roomAndCareerLabel{
    if (!_roomAndCareerLabel) {
        _roomAndCareerLabel = [[UILabel alloc]init];
        _roomAndCareerLabel.font = [UIFont systemFontOfSize:15];
        _roomAndCareerLabel.textColor = [UIColor blackColor];
    }
    return _roomAndCareerLabel;
}

-(UILabel *)hospitalLabel{
    if (!_hospitalLabel) {
        _hospitalLabel = [[UILabel alloc]init];
        _hospitalLabel.font = [UIFont systemFontOfSize:15];
        _hospitalLabel.textColor = [UIColor blackColor];
    }
    return _hospitalLabel;
}

-(UILabel *)goodatLabel{
    if (!_goodatLabel) {
        _goodatLabel = [[UILabel alloc]init];
        _goodatLabel.font = [UIFont systemFontOfSize:15];
        _goodatLabel.textColor = [UIColor blackColor];
    }
    return _goodatLabel;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

-(UILabel *)infoLabel1{
    if (!_infoLabel1) {
        _infoLabel1 = [[UILabel alloc]init];
        _infoLabel1.font = [UIFont systemFontOfSize:15];
        _infoLabel1.textColor = [UIColor colorFromHexString:@"bfbfbf"];
        _infoLabel1.text = @"个人简介";
    }
    return _infoLabel1;
}

-(UILabel *)qRLabel{
    if (!_qRLabel) {
        _qRLabel = [[UILabel alloc]init];
        _qRLabel.font = [UIFont systemFontOfSize:14];
        _qRLabel.textColor = [UIColor colorFromHexString:@"bfbfbf"];
        _qRLabel.text = @"[扫一扫二维码,立即添加我]";
    }
    return _qRLabel;
}

@end
