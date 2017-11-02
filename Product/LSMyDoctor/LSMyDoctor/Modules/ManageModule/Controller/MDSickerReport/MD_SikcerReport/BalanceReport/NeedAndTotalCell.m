//
//  NeedAndTotalCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/10.
//
//

#import "NeedAndTotalCell.h"

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0green:(((s &0xFF00) >>8))/255.0blue:((s &0xFF))/255.0alpha:1.0]

@interface NeedAndTotalCell()

@property (nonatomic, strong) UILabel * allGetTitleL;   //“今日能量总摄入”标题
@property (nonatomic, strong) UILabel * allUseL;        //“总消耗标题”
@property (nonatomic, strong) UILabel * allGetCount;    //摄入千卡
@property (nonatomic, strong) UILabel * allUseCount;    //消耗千卡
@property (nonatomic, strong) UILabel * allGetUnit;     //输入单位
@property (nonatomic, strong) UILabel * allUseUnit;     //消耗单位

@end

@implementation NeedAndTotalCell{
 

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = UIColorFromRGB(0xf1faff);
        
        self.allGetTitleL            = [[UILabel alloc] init];
        self.allGetTitleL.font       = [UIFont systemFontOfSize:19];
        self.allGetTitleL.textColor  = UIColorFromRGB(0x212121);
        self.allGetTitleL.text       = @"您今日能量总摄入为:";
        
        self.allUseL                 = [[UILabel alloc] init];
        self.allUseL.font            = [UIFont systemFontOfSize:19];
        self.allUseL.textColor       = UIColorFromRGB(0x212121);
        self.allUseL.text            = @"您今日能量总消耗为:";
        
        self.allGetCount             = [[UILabel alloc] init];
        self.allGetCount.font        = [UIFont systemFontOfSize:40];
        self.allGetCount.textColor   = UIColorFromRGB(0x41d079);
        self.allGetCount.text        = @"0";

        
        self.allUseCount             = [[UILabel alloc] init];
        self.allUseCount.font        = [UIFont systemFontOfSize:40];
        self.allUseCount.textColor   = UIColorFromRGB(0x41d079);
        self.allUseCount.text        = @"0";
        
        self.allGetUnit              = [[UILabel alloc] init];
        self.allGetUnit.font         = [UIFont systemFontOfSize:18];
        self.allGetUnit.text         = @"千卡";
        
        self.allUseUnit              = [[UILabel alloc] init];
        self.allUseUnit.font         = [UIFont systemFontOfSize:18];
        self.allUseUnit.text         = @"千卡";
        
        
        [self.contentView addSubview:self.allGetTitleL];
        [self.contentView addSubview:self.allUseL];
        [self.contentView addSubview:self.allGetCount];
        [self.contentView addSubview:self.allUseCount];
        [self.contentView addSubview:self.allGetUnit];
        [self.contentView addSubview:self.allUseUnit];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    CGFloat top1 = 14;
    CGFloat top2 = 39;
    CGFloat top3 = 80;
    
    // 总摄入：标题
    [self.allGetTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top1);
        make.left.equalTo(self).with.offset(21);
    }];
    self.allGetTitleL.text       = @"您今日能量总摄入为:";

    
    // 总摄入：数值
    [self.allGetCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(top2);
    }];
    
    // 总摄入：单位
    [self.allGetUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.allGetCount).with.offset(-10);
        make.leading.equalTo(self.allGetCount.mas_trailing).with.offset(2);
    }];
    
    // 总消耗：标题
    [self.allUseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top1 + top3);
        make.left.equalTo(self).offset(21);
    }];
    
    // 总消耗：数值
    [self.allUseCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.allUseL).with.offset(top2);
    }];
    
    // 总消耗：单位
    [self.allUseUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.allUseCount).with.offset(-10);
        make.leading.equalTo(self.allUseCount.mas_trailing).with.offset(2);
    }];
}

- (void)setModel:(BalanceGroups *)model{
    _model = model;
    if (model.items.count > 0) {
        
        NSString * getstr = [NSString stringWithFormat:@"%@:", model.items[0].data.name];
        self.allGetTitleL.text = getstr;
        self.allGetCount.text = model.items[0].data.value;
        self.allGetUnit.text = model.items[0].data.unit;
        
        NSString * usestr = [NSString stringWithFormat:@"%@:", model.items[1].data.name];
        self.allUseL.text = usestr;
        self.allUseCount.text = model.items[1].data.value;
        self.allUseUnit.text = model.items[1].data.unit;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
