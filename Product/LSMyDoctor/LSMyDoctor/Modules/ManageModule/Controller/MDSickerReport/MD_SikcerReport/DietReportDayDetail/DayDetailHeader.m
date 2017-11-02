//
//  DayDetailHeader.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/11.
//
//

#import "DayDetailHeader.h"
#import "DietDefine.h"
@interface DayDetailHeader()
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * tasteBtn;
@property (nonatomic, strong) UIView * linetop;
@property (nonatomic, strong) UIView * linebottom;
@property (nonatomic, strong) UIView * bgv;
@end
@implementation DayDetailHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        self.tasteBtn = [[UIButton alloc] init];
        self.linetop = [[UIView alloc] init];
        self.linebottom = [[UIView alloc] init];
        self.bgv = [[UIView alloc] init];
        
        [self.contentView addSubview:self.bgv];
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.nameLabel];
        [self addSubview:self.tasteBtn];
        [self.contentView addSubview:self.linetop];
        [self.contentView addSubview:self.linebottom];
        
    
    }
    return self;
}

- (void)layoutSubviews{
    self.bgv.backgroundColor = [UIColor whiteColor];
    [self.bgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = UIColorFromRGB(0x5593e8);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
    }];
    
    self.tasteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.tasteBtn setTitle:@"口味" forState:UIControlStateNormal];
    [self.tasteBtn setTitleColor:UIColorFromRGB(0xe98f36) forState:UIControlStateNormal];
    self.tasteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.tasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.right.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self);
    
    }];
    
    self.tasteBtn.layer.masksToBounds = YES;
    self.tasteBtn.layer.borderColor = UIColorFromRGB(0xe98f36).CGColor;
    self.tasteBtn.layer.borderWidth = 0.6;
    self.tasteBtn.layer.cornerRadius = self.tasteBtn.frame.size.width / 2.0f;
    [self.tasteBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.linetop.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.linetop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
    
    
    self.linebottom.backgroundColor = UIColorFromRGB(0xcccccc);

    [self.linebottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
    
}

- (void)setModel:(SelectedfoodlistModel *)model{
    _model = model;
    self.nameLabel.text = model.eatTypeName;
  
    if (model.eatTypeID == 8) {
        self.tasteBtn.alpha = 0;
    }else{
        self.tasteBtn.alpha = 1;
    }

}

#pragma mark-点击口味回调
- (void)onClick{
    NSLog(@"dianji");
    self.tBlock();
}
@end
