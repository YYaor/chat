//
//  CureSelCollectionViewCell.m
//  YouGeHealth
//
//  Created by earlyfly on 16/10/13.
//
//

#import "CureSelCollectionViewCell.h"

#define RemindFont 17
@interface CureSelCollectionViewCell (){
    
    UIView *bgView;
    UILabel *remindLabel;
    
    UIImageView *imageView;
    
    UILongPressGestureRecognizer *tap;
}


@end

@implementation CureSelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.layer.borderWidth = 1.5;
    
    self.layer.borderColor = BaseColor.CGColor;
    self.clipsToBounds = YES;
//    self.layer.masksToBounds = YES;

    self.layer.cornerRadius = 5;

    if (LSSCREENWIDTH > 375) {
        _contentLabel.font = [UIFont systemFontOfSize:19];
    }
    
}

-(void)setAnswerText:(NSString *)answerText{
    
    _answerText = answerText;
    self.contentLabel.text = answerText;
//    self.contentLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)titleLabelLongTap:(UILongPressGestureRecognizer *) tap{
    
    NSLog(@"%@===%@",_answerText,_remindStr);
    if (_remindStr.length > 0) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        CGRect rct1 = [self convertRect:self.frame fromView:[self superview]];
        CGRect rct2 = [self convertRect:rct1 toView:window];
        NSLog(@"%lf,%lf", rct2.origin.x, rct2.origin.y);
        CGFloat height = self.frame.size.height;
        //    CGFloat x = rct2.origin.x + height;
        CGFloat y = rct2.origin.y + height;
        
        [bgView removeFromSuperview];
        bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
        [bgView addGestureRecognizer:bgViewTap];
        bgView.backgroundColor = [UIColor clearColor];
        [window addSubview:bgView];
        
        [remindLabel removeFromSuperview];
        CGFloat contentLabelW = _contentLabel.frame.size.width;
        CGFloat x = 20 + (contentLabelW + 10)*(_row%3);
        CGFloat remindWidth = _remindStr.length * RemindFont > LSSCREENWIDTH - 10 - x?LSSCREENWIDTH - 20 - x:_remindStr.length * RemindFont;
        remindLabel.backgroundColor = [UIColor redColor];
        remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y + 20, remindWidth, 100)];
        remindLabel.text = _remindStr;
        remindLabel.font = [UIFont systemFontOfSize:RemindFont];
        remindLabel.textColor = [UIColor whiteColor];
        remindLabel.numberOfLines = 0;
        [remindLabel sizeToFit];
        
        [imageView removeFromSuperview];
        UIImage *image = [UIImage imageNamed:@"bubble"];
        CGFloat bgWidth = _remindStr.length * RemindFont > kScreenWidth - 10 - x?LSSCREENWIDTH - 10 - x:_remindStr.length * RemindFont+6;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x - 6, y, bgWidth, remindLabel.frame.size.height + 30)];
        
        // 设置按钮的背景图片
        imageView.image = image;
        
        [window addSubview:imageView];
        [window addSubview:remindLabel];
    }
    
}

- (void)setRemindStr:(NSString *)remindStr{
    
    _remindStr = remindStr;
    NSLog(@"%@===%@",_answerText,_remindStr);
    if (remindStr.length > 0) {
        tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelLongTap:)];
        self.userInteractionEnabled = YES;
//        tap.cancelsTouchesInView = NO;//手势冲突
        [self addGestureRecognizer:tap];
    }else{
        [self removeGestureRecognizer:tap];
    }
}

- (void)bgViewTap:(UITapGestureRecognizer *)tap{
    
    [imageView removeFromSuperview];
    [bgView removeFromSuperview];
    [remindLabel removeFromSuperview];
    
    
}

//#pragma mark tapGestureRecgnizerdelegate 解决手势冲突
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"%@",otherGestureRecognizer.view);
//    if ([otherGestureRecognizer.view isKindOfClass:[CureSelCollectionViewCell class]]){
//        return YES;
//    }
//    return NO;
//}

@end
