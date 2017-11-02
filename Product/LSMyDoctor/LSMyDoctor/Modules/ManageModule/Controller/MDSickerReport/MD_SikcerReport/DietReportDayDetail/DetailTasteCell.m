//
//  DetailTasteCell.m
//  YouGeHealth
//
//  Created by yunzujia on 16/11/11.
//
//

#import "DetailTasteCell.h"


@interface DetailTasteCell()


@property (nonatomic, strong) UILabel * nameLabel;//口味题目的名称
@property (nonatomic, strong) UILabel * describLabel;//题目下选择的答案，显示在右侧

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * bottomLine;
@end
@implementation DetailTasteCell{
    CGSize exSize;//答案label显示size
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        self.describLabel = [[UILabel alloc] init];
        self.topLine = [[UIView alloc] init];
        self.bottomLine = [[UIView alloc] init];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.describLabel];
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews{
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    self.nameLabel.textColor = UIColorFromRGB(0x5e5e5e);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.left.equalTo(self).with.offset(10);
    }];
    
    self.describLabel.font = [UIFont systemFontOfSize:19];
    self.describLabel.textColor = UIColorFromRGB(0x212121);
    
    
    self.topLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
    
    
    self.bottomLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.bottomLine  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.6);
    }];
    
    
    [self.describLabel setFrame:CGRectMake(self.bounds.size.width - exSize.width - 10, 20, exSize.width, exSize.height)];
}

- (void)setModel:(QAModel *)model{
    _model = model;
    NSLog(@"model");
    self.nameLabel.text = model.title;
    
    NSMutableString * str = [[NSMutableString alloc] init];
    if (model.anser.count > 0) {
        for (int i = 0; i < model.anser.count; i ++) {
            if (model.anser.count > 1) {
                if (i == model.anser.count - 1) {
                    [str appendFormat:@"%@", model.anser[i]];
                }else{
                    [str appendFormat:@"%@、", model.anser[i]];
                }
            }else{
                [str appendFormat:@"%@", model.anser[0]];
            }
        }
    }
    if (str.length > 0) {
        self.describLabel.text = str;
    }else{
        self.describLabel.text = @"";
    }
    self.describLabel.numberOfLines = 2;
    self.describLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.nameLabel setNeedsLayout];
    [self.nameLabel layoutIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize max = CGSizeMake(self.bounds.size.width/2.0f, self.nameLabel.frame.size.height * 2);
    exSize = [self.describLabel sizeThatFits:max];
    
   // NSLog(@"描述标签的位置－%f", self.bounds.size.width - exSize.width - 10);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
