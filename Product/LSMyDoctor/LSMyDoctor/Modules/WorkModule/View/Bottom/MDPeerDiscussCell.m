//
//  MDPeerDiscussCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/22.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDPeerDiscussCell.h"

@interface MDPeerDiscussCell()

@property (weak, nonatomic) IBOutlet UIView *starView;//星级View
@property (weak, nonatomic) IBOutlet UILabel *sickNameLab;//疾病名称
@property (weak, nonatomic) IBOutlet UILabel *discussValueLab;//评价内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussValueLabHeight;//评价内容的高度
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;//患者名称
@property (weak, nonatomic) IBOutlet UILabel *discussTimeLab;//评价时间

@end

@implementation MDPeerDiscussCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView* starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(32 * i, 0, 30, 30)];
        
        starImgView.image = [UIImage imageNamed:@"people_blue"];
        
        starImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.starView addSubview:starImgView];
        
        
    }
    
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
