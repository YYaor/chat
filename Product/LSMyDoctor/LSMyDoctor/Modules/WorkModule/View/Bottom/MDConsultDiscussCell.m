//
//  MDConsultDiscussCell.m
//  MyDoctor
//
//  Created by WangQuanjiang on 17/9/20.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDConsultDiscussCell.h"
@interface MDConsultDiscussCell()

@property (weak, nonatomic) IBOutlet UIImageView *groupImgView;//组像
@property (weak, nonatomic) IBOutlet UILabel *groupNameLab;//组名称
@property (weak, nonatomic) IBOutlet UILabel *valueLab;//聊天
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间

@end

@implementation MDConsultDiscussCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(MDDiscussListModel *)listModel
{
    _listModel = listModel;
    
    [self.groupImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UGAPI_HOST,listModel.img_url]] placeholderImage:[UIImage imageNamed:@"people_blue"]];
    self.groupNameLab.text = [NSString stringWithFormat:@"%@患者的讨论组",listModel.name];
    
    
    
    
}


@end
