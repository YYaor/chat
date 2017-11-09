//
//  LSWorkArticleCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/8.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSWorkArticleCell.h"

@interface LSWorkArticleCell ()

//底图
@property (nonatomic,strong)UIView *backBGView;
//删除蒙层
@property (nonatomic,strong)UIView *deleteView;
//删除按钮
@property (nonatomic,strong)UIButton *deleteButton;
//标题
@property (nonatomic,strong)UILabel *titleLabel;
//信息
@property (nonatomic,strong)UILabel *infoLabel;
//一张图或者视频
@property (nonatomic,strong)UIImageView *imageViewOne;
//两张图
@property (nonatomic,strong)UIImageView *imageViewTwo;
//三张图
@property (nonatomic,strong)UIImageView *imageViewTree;
//时间
@property (nonatomic,strong)UILabel *timeLabel;
//状态
@property (nonatomic,strong)UILabel *statusLabel;

@end

@implementation LSWorkArticleCell

-(UIView *)backBGView{
    if (!_backBGView) {
        _backBGView = [[UIView alloc]init];
        _backBGView.layer.borderColor = [UIColor colorFromHexString:LSLIGHTGRAYCOLOR].CGColor;
        _backBGView.layer.borderWidth = 1;
        _backBGView.layer.cornerRadius = 4;
        [_backBGView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGester:)]];
    }
    return _backBGView;
}

-(UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView alloc]init];
        _deleteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _deleteView.hidden = YES;
        [_deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearView)]];
    }
    return _deleteView;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"del_red_Public"] forState:UIControlStateNormal];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.cornerRadius = 30;
        _deleteButton.backgroundColor = [UIColor whiteColor];
    }
    return _deleteButton;
}

-(UIImageView *)imageViewOne{
    if (!_imageViewOne) {
        _imageViewOne = [[UIImageView alloc]init];
        _imageViewOne.backgroundColor = [UIColor redColor];
    }
    return _imageViewOne;
}

-(UIImageView *)imageViewTwo{
    if (!_imageViewTwo) {
        _imageViewTwo = [[UIImageView alloc]init];
        _imageViewTwo.backgroundColor = [UIColor redColor];
    }
    return _imageViewTwo;
}

-(UIImageView *)imageViewTree{
    if (!_imageViewTree) {
        _imageViewTree = [[UIImageView alloc]init];
        _imageViewTree.backgroundColor = [UIColor redColor];
    }
    return _imageViewTree;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"这是标题";
    }
    return _titleLabel;
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.numberOfLines = 2;
        _infoLabel.text = @"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容";
    }
    return _infoLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.text = @"这是时间";
    }
    return _timeLabel;
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [UIColor blackColor];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.text = @"状态";
    }
    return _statusLabel;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}


-(void)longGester:(UILongPressGestureRecognizer *)longGester{
    self.deleteView.hidden = NO;
}

-(void)initUI
{
    [self.contentView addSubview:self.backBGView];
    
    [self.backBGView addSubview:self.titleLabel];
    [self.backBGView addSubview:self.infoLabel];
    [self.backBGView addSubview:self.timeLabel];
    [self.backBGView addSubview:self.statusLabel];
    [self.backBGView addSubview:self.imageViewOne];
    [self.backBGView addSubview:self.imageViewTwo];
    [self.backBGView addSubview:self.imageViewTree];
    
    [self.backBGView addSubview:self.deleteView];
    [self.deleteView addSubview:self.deleteButton];
    
    [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.backBGView);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.deleteView.mas_centerX);
        make.centerY.equalTo(self.deleteView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.backBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backBGView).offset(20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backBGView).offset(-20);
        make.left.equalTo(self.backBGView).offset(20);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backBGView).offset(-20);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBGView).offset(20);
        make.right.equalTo(self.backBGView).offset(-20);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-10);
    }];
    
    [self.imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoLabel.mas_top).offset(-10);
        make.left.equalTo(self.backBGView).offset(20);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width/3);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-80);
    }];
    
    [self.imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageViewOne.mas_centerY);
        make.left.equalTo(self.imageViewOne.mas_right).offset(10);
        make.height.mas_equalTo(self.imageViewOne.mas_height);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-80);
    }];
    
    [self.imageViewTree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageViewOne.mas_centerY);
        make.left.equalTo(self.imageViewTwo.mas_right).offset(10);
        make.height.mas_equalTo(self.imageViewOne.mas_height);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-80);
    }];
    
    [self layoutIfNeeded];
}

-(void)deleteButtonClick{
    //删除按钮
}

-(void)clearView{
    self.deleteView.hidden = YES;
}

-(void)setData:(NSMutableDictionary *)data{
//    author_id	作者ID	number
//    classify	文章分类	number
//    content	文章概述	string
//    create_time	发布时间	number	yyyy-MM-dd HH:mm:ss
//    doctor_name	作者姓名	string	为空显示：来源：佑格健康
//    files	文件路径	string	以“,”号分隔
//    id	文章ID	number
//    source	来源	number	1医生 2后台
//    title	文章标题	string
//    type	文章类型	number	1单图 2多图 3视频 4无图
    self.timeLabel.text = data[@"create_time"];
    self.titleLabel.text = data[@"title"];
    self.infoLabel.text = data[@"content"];
    if (data[@"files"]) {
        NSArray *urlArray = [data[@"files"] componentsSeparatedByString:@","];
        if (urlArray.count == 0) {
            self.imageViewOne.hidden = YES;
            self.imageViewTwo.hidden = YES;
            self.imageViewTree.hidden = YES;
        }else if (urlArray.count == 1){
            self.imageViewOne.hidden = NO;
            self.imageViewTwo.hidden = YES;
            self.imageViewTree.hidden = YES;
            [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[0]]] placeholderImage:nil];

        }else if (urlArray.count == 2){
            self.imageViewOne.hidden = NO;
            self.imageViewTwo.hidden = NO;
            self.imageViewTree.hidden = YES;
            
            [self.imageViewOne mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-80-10)/2);
            }];
            
            [self.imageViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-80-10)/2);
            }];
            
            [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[0]]] placeholderImage:nil];
            
            [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[1]]] placeholderImage:nil];
            
        }else if (urlArray.count == 3){
            self.imageViewOne.hidden = NO;
            self.imageViewTwo.hidden = NO;
            self.imageViewTree.hidden = NO;
            
            [self.imageViewOne mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-80-20)/3);
            }];
            
            [self.imageViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-80-20)/3);
            }];
            
            [self.imageViewTree mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-80-20)/3);
            }];
            
            [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[0]]] placeholderImage:nil];
            
            [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[1]]] placeholderImage:nil];
            
            [self.imageViewTree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", UGAPI_HOST,urlArray[2]]] placeholderImage:nil];
            
        }else{
            self.imageViewOne.hidden = YES;
            self.imageViewTwo.hidden = YES;
            self.imageViewTree.hidden = YES;
        }
    }else{
        self.imageViewOne.hidden = YES;
        self.imageViewTwo.hidden = YES;
        self.imageViewTree.hidden = YES;
    }
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
