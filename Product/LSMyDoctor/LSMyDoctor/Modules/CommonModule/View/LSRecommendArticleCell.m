//
//  LSRecommendArticleCell.m
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/11/15.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import "LSRecommendArticleCell.h"

@interface LSRecommendArticleCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIImageView *selImgView;

@end

@implementation LSRecommendArticleCell

- (void)setDataWithModel:(LSRecommendArticleModel *)model
{
    self.title.text = model.title;
    self.content.text = model.content;
    
    if (!model.isSel)
    {
        [self.selImgView setImage:[UIImage imageNamed:@"unSelectBox_Public"]];
    }
    else
    {
        [self.selImgView setImage:[UIImage imageNamed:@"selectedBox_Public"]];
    }
}

@end
