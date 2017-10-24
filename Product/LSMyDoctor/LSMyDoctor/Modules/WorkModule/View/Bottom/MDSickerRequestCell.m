//
//  MDSickerRequestCell.m
//  MyDoctor
//
//  Created by 惠生 on 17/7/31.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDSickerRequestCell.h"
@interface MDSickerRequestCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;//姓名

@property (weak, nonatomic) IBOutlet UILabel *userValueLab;//请求内容

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;//同意

@property (weak, nonatomic) IBOutlet UILabel *sexAndAgeLab;//性别和年龄




@end

@implementation MDSickerRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius = 4.5f;
    
    self.userImgView.layer.masksToBounds = YES;
    self.userImgView.layer.cornerRadius = 20.0f;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentModel:(MDRequestContentModel *)contentModel
{
    _contentModel = contentModel;
    
    //头像
    
    NSString* imgUrl = [NSString stringWithFormat:@"%@%@",UGAPI_HOST,contentModel.img_url];
    [self.userImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"headImg_public"]];
    //姓名
    self.userNameLab.text = contentModel.username;
    //性别和年龄
    self.sexAndAgeLab.text = @"";
    
    //用户申请内容
    if (!contentModel.remark || contentModel.remark.length <= 0) {
        self.userValueLab.text = @"请同意我的请求";
    }else{
        self.userValueLab.text = contentModel.remark;
    }
    
    if ([contentModel.result isEqualToString:@"已通过"]) {
        self.agreeBtn.hidden = YES;
        UILabel* resultLab = [[UILabel alloc] init];
        
        resultLab.text = contentModel.result;
        resultLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:resultLab];
        [resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        
    }else{
        self.agreeBtn.hidden = NO;
    }

    
    
}


#pragma mark -- 同意按钮点击
- (IBAction)agreeBtnClick:(UIButton *)sender
{
    [self.delegate mDSickerRequestCellDelegateAgreeBtnClickWithSickerModel:_contentModel];
}


@end
