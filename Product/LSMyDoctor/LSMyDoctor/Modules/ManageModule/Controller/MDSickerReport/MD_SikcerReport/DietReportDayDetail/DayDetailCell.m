//
//  DayDetailCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/11.
//
//

#import "DayDetailCell.h"
#import "DietDefine.h"
@interface DayDetailCell()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UIView * bottomLine;
@end
@implementation DayDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        self.countLabel = [[UILabel alloc] init];
        self.bottomLine = [[UIView alloc] init];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews{
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    self.nameLabel.textColor = UIColorFromRGB(0x212121);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
    }];
    
    
    self.countLabel.font = [UIFont systemFontOfSize:16];
    self.countLabel.textColor = UIColorFromRGB(0x9d9d9d);
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(10);
    }];
    
    
    self.bottomLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.3);
        make.bottom.equalTo(self);
    }];

}

- (void)setModel:(DatainModel *)model{
    _model = model;
    if (model.foodName) {
        self.nameLabel.text = model.foodName;
    }
    CGFloat unitcout = 0.0;
    NSString * unitname = model.unitName;
    for (int i = 0; i < self.model.unitList.count; i ++) {
        if ([unitname isEqualToString:self.model.unitList[i].unitName]) {
            if(i == 0){
                unitcout = self.model.unitQty/100;
            }else{
                unitcout = self.model.unitList[i].unitQty * self.model.unitQty / 100;
            }
            
        }
    }
    //显示已选择的量
    self.countLabel.text = [NSString stringWithFormat:@"%ld%@", (long)model.unitQty, model.unitName];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
