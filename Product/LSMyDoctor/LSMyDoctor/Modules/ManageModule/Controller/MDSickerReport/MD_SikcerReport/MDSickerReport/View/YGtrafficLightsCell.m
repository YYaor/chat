                                                                                                                   //
//  YGtrafficLightsCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/11/3.
//
//

#import "YGtrafficLightsCell.h"

@interface YGtrafficLightsCell ()

//@property (weak, nonatomic) IBOutlet UIImageView *lightImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *lightImageView;

@end

@implementation YGtrafficLightsCell

- (void)awakeFromNib {
    // Initialization code
}


//-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
//    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self initLayuot];
//    }
//    return self;
//}
////初始化控件
//-(void)initLayuot{
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 5, 250, 40)];
//    [self addSubview:_titleLabel];
//    _lightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 66, 66)];
//    [self addSubview:_lightImageView];
////    _introduction = [[UILabel alloc] initWithFrame:CGRectMake(5, 78, 250, 40)];
////    [self addSubview:_introduction];
//}
//
//- (void)setDataModel:(ReportItemDataModel *)dataModel{
//    
//    //获得当前cell高度
//    CGRect frame = [self frame];
//    //文本赋值
//    //self.introduction.text = text;
//    //设置label的最大行数
//    //self.introduction.numberOfLines = 10;
//    CGSize size = CGSizeMake(300, 1000);
//    CGSize labelSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    self.introduction.frame = CGRectMake(self.introduction.frame.origin.x, self.introduction.frame.origin.y, labelSize.width, labelSize.height);
//    
//    //计算出自适应的高度
//    frame.size.height = labelSize.height+100;
//    
//    self.frame = frame;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(ReportItemDataModel *)dataModel{
    
    _dataModel = dataModel;
    
    __weak typeof(self) weakSelf = self;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }

    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
        make.height.equalTo(@20);
    }];
    titleLabel.text = @"佑格红绿灯";
    titleLabel.textColor = RGBCOLOR(64, 142, 236);
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.height.equalTo(@35);
        make.width.equalTo(@90);
    }];
    //红1 黄2 绿3
    switch (dataModel.light) {
        case 1:
            imageView.image = [UIImage imageNamed:@"trafficlight-red"];
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"trafficlight-yellow"];
            break;
        case 3:
            imageView.image = [UIImage imageNamed:@"trafficlight-green"];
            break;
            
        default:
            break;
    }
    if (dataModel.list.count > 0) {
        
        UILabel *noticeTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:noticeTitleLabel];
        [noticeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.height.equalTo(@20);
        }];
        noticeTitleLabel.attributedText = [WFLayoutHelper mixImage:[UIImage imageNamed:@"trangle_red_down"] text:@"需关注项" fontSize:16];

        UILabel *textContentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:textContentLabel];
        [textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noticeTitleLabel.mas_bottom).offset(5);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        NSArray *listArr = dataModel.list;
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] init];
        for (int i = 0; i < listArr.count; ++i) {
            
            
            [mutStr  appendAttributedString:[WFLayoutHelper mixImageFront:[UIImage imageNamed:@"tips_green"] textBack:listArr[i]]];
            if (i != listArr.count - 1 ) {
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"\n"];
                [mutStr appendAttributedString:attrStr];
            }
        }
        textContentLabel.attributedText = mutStr;
        textContentLabel.numberOfLines = 0;
    }else{
        
        
        UILabel *tLabel = [[UILabel alloc] init];
        tLabel.numberOfLines = 0;
        [self.contentView addSubview:tLabel];
        [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.contentView.mas_left).offset(20);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-20);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        }];
        //tLabel.text = @"案发啊哈贷款卡号案例拉黑阿兰卡拉拉哈喽拉开拉开案例拉拉拉拉黑拉黑啦啦啦拉黑啦拉黑拉开拉拉案例拉案例案例拉案例啊案例拉哈维和卡哈
    }
}

@end
