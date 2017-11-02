//
//  BalanceCellTableViewCell.m
//  ceshi
//
//  Created by yunzujia on 16/11/10.
//  Copyright © 2016年 yunzujia. All rights reserved.
//

#import "BalanceCellTableViewCell.h"

#define YCBUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BalanceCellTableViewCell()

@property (nonatomic, strong) UILabel * allStoreTitleLabel;   //“今日能量存储”标题
@property (nonatomic, strong) UILabel * allStoreCount;        //能量存储值
//@property (nonatomic, strong) UILabel * allStoreUnit;         //能量存储单位

@property (nonatomic, strong) UILabel * yougeTitle;           //“今日能量平衡佑格分”
@property (nonatomic, strong) UILabel * yougeCount;           //今日能量平衡佑格分值
//@property (nonatomic, strong) UILabel * yougeUnit;            //今日能量平衡佑格单位

@property (nonatomic, strong) UIImageView * imageview;  //灯泡
@property (nonatomic, strong) UILabel     * sayLabel;

@end
@implementation BalanceCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.allStoreTitleLabel = [[UILabel alloc] init];
        self.yougeTitle         = [[UILabel alloc] init];
        self.allStoreCount      = [[UILabel alloc] init];
        self.yougeCount         = [[UILabel alloc] init];
        self.imageview          = [[UIImageView alloc] init];
        self.sayLabel           = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.allStoreTitleLabel];
        [self.contentView addSubview:self.yougeTitle];
        [self.contentView addSubview:self.allStoreCount];
        [self.contentView addSubview:self.yougeCount];
        [self.contentView addSubview:self.imageview];
        [self.contentView addSubview:self.sayLabel];
        
        self.allStoreTitleLabel.font      = [UIFont systemFontOfSize:19];
        //self.allStoreTitleLabel.textColor = UIColorFromRGB(0xffb434);
        
        self.yougeTitle.font      = [UIFont systemFontOfSize:19];
        //self.yougeTitle.textColor = UIColorFromRGB(0xffb434);
        
        self.sayLabel.font = [UIFont systemFontOfSize:18];
        self.sayLabel.textColor = YCBUIColorFromRGB(0x212121);
        
        self.imageview.image = [UIImage imageNamed:@"light"];
        
        self.backgroundColor = UIColorFromRGB(0xf1faff);
    }
    return self;
}

- (CGSize) boundingRectWithSize:(CGSize)size forLabel:(UILabel*) label
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    
    CGSize retSize = [label.text boundingRectWithSize:size
                                             options:  NSStringDrawingTruncatesLastVisibleLine |
                                                       NSStringDrawingUsesLineFragmentOrigin   |
                                                       NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

- (void)layoutSubviews{
    
    CGFloat top1 = 14;
    CGFloat top2 = 45;
    CGFloat top3 = 95;
    
    [self.allStoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top1);
        make.left.equalTo(self).with.offset(21);
    }];
        
    [self.allStoreCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top2);
        make.centerX.equalTo(self);
    }];
    
    [self.yougeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top1 + top3);
        make.left.equalTo(self).offset(21);
        
    }];
    
    [self.yougeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(top2 + top3);
        make.centerX.equalTo(self);
    }];

    self.sayLabel.numberOfLines = 0;
    self.sayLabel.textAlignment = NSTextAlignmentCenter;
    self.sayLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.sayLabel.layer.masksToBounds = YES;
    self.sayLabel.layer.cornerRadius = 5;
    self.sayLabel.layer.borderWidth = 1;
    self.sayLabel.layer.borderColor = UIColorFromRGB(0x41d07d).CGColor;
    
    CGRect sayFrame = CGRectMake(50, top2 + top3 + 60, [UIScreen mainScreen].bounds.size.width - 40, 0);
    self.sayLabel.frame = sayFrame;
    CGSize labelSize = [self boundingRectWithSize:CGSizeMake(sayFrame.size.width, 0) forLabel:self.sayLabel];
    CGFloat extendY = 16;
    sayFrame = CGRectMake(50, top2 + top3 + 60, [UIScreen mainScreen].bounds.size.width - 40, labelSize.height + extendY);
    sayFrame.origin.x = ([UIScreen mainScreen].bounds.size.width - sayFrame.size.width) / 2;
    sayFrame.origin.x += 9; //右移，使得灯泡和文字作为整体居中
    self.sayLabel.frame = sayFrame;
    
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sayLabel).with.offset(10);
        make.trailing.equalTo(self.sayLabel.mas_leading).with.offset(-5);
    }];
    
    if (!self.model) {
        self.allStoreTitleLabel.text = @"您今日能量总存储为:";
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", @"0", @"千卡"]];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:40] range:NSMakeRange(0,1)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffb434) range:NSMakeRange(0, 1)];
        self.allStoreCount.attributedText = str;
        
        self.yougeTitle.text = @"您今日能量平衡佑格分为:";
        
        NSMutableAttributedString * str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", @"0", @"分"]];
        [str2 addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:40] range:NSMakeRange(0,1)];
        [str2 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffb434) range:NSMakeRange(0, 1)];
        self.yougeCount.attributedText = str2;
    }
}

- (void)setModel:(BalanceGroups *)model{
    _model = model;
    if(model.items.count > 0 ){
        
        // 总存储：标题
        self.allStoreTitleLabel.text = model.items[0].data.name;
        
        // 分值及单位
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.items[0].data.value, model.items[0].data.unit]];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, model.items[0].data.value.length)];
        UIColor *allStoredColor = UIColorFromRGB(0x41d079);
        if (model.items[0].data.color == 2)
        {
            allStoredColor = UIColorFromRGB(0xffb434);
        }
        [str addAttribute:NSForegroundColorAttributeName value:allStoredColor range:NSMakeRange(0, model.items[0].data.value.length)];
        self.allStoreCount.attributedText = str;
        
        // 佑格分标题
        self.yougeTitle.text = model.items[1].data.name;
        
        // 佑格分值及单位
        NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.items[1].data.value,  model.items[1].data.unit] ];
        [str1 addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, model.items[1].data.value.length)];
        UIColor *yougeValueColor = UIColorFromRGB(0x41d079);
        if (model.items[1].data.color == 2)
        {
            yougeValueColor = UIColorFromRGB(0xffb434);
        }
        [str1 addAttribute:NSForegroundColorAttributeName value:yougeValueColor range:NSMakeRange(0, model.items[1].data.value.length)];
        self.yougeCount.attributedText = str1;
        
        // 消息汇总标签
        NSString * saystr = model.items[2].data.list[0];
        self.sayLabel.font = [UIFont systemFontOfSize:18];
        self.sayLabel.textColor = YCBUIColorFromRGB(0x212121);
        self.sayLabel.text = saystr;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
