//
//  MDUsefulMarkCell.m
//  MyDoctor
//
//  Created by 惠生 on 17/7/12.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDUsefulMarkCell.h"
@interface MDUsefulMarkCell()

@property (weak, nonatomic) IBOutlet UIView *userfulMarkView;//常用标签内容

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markViewHeight;

@end

@implementation MDUsefulMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markViewHeight.constant = 100.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUsefulMarkArr:(NSMutableArray *)usefulMarkArr
{
    _usefulMarkArr = usefulMarkArr;
    NSLog(@"%@",usefulMarkArr);
    
    for (UIView* v in self.userfulMarkView.subviews) {
        [v removeFromSuperview];
    }
    
    NSInteger numRow = 1;//取行数，向上取整
    if (usefulMarkArr.count >= 4) {
        numRow = (NSInteger)ceilf((float)(usefulMarkArr.count+1)/4);
    }
    
    CGFloat labelWidth = (LSSCREENWIDTH - 25)/4;
    CGFloat labelHeight = labelWidth/2;
    
    self.markViewHeight.constant = numRow * labelHeight +  16;
    
    
    for (int i = 0; i < numRow; i++) {
        for(int j = 0 ;j < 4; j ++){
            WFHelperButton* markBtn = [[WFHelperButton alloc] initWithFrame:CGRectMake((labelWidth + 5)*j , (labelHeight + 8)*i, labelWidth, labelHeight)];
            
            if (4 * i + j  > usefulMarkArr.count -1) {
                [markBtn setTitle:@"测试" forState:UIControlStateNormal];
            }else if (4 * i + j  == usefulMarkArr.count -1){
                //最后一项，自定义
//                [markBtn setBackgroundImage:[UIImage imageNamed:@"user_definde"] forState:UIControlStateNormal];
                markBtn.layer.masksToBounds = YES;
                markBtn.layer.cornerRadius = labelHeight/2;
                markBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                markBtn.layer.borderWidth = 1.0f;
                
                [markBtn setTitle:@"+自定义" forState:UIControlStateNormal];
                
                
                [markBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                markBtn.flagStr = @"-1";
            }else{
                
                markBtn.layer.masksToBounds = YES;
                markBtn.layer.cornerRadius = labelHeight/2;
                markBtn.layer.borderColor = BaseColor.CGColor;
                markBtn.layer.borderWidth = 1.0f;
                
                [markBtn setTitle:usefulMarkArr[4*i+j] forState:UIControlStateNormal];
                
                [markBtn setTitleColor:BaseColor forState:UIControlStateNormal];
                markBtn.flagStr = usefulMarkArr[4*i+j];
                
            }
            
           
            [markBtn addTarget:self action:@selector(markBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.userfulMarkView addSubview:markBtn];
            
            if (4 * i + j  > usefulMarkArr.count -1) {
                markBtn.hidden = YES;
            }else{
                markBtn.hidden = NO;
            }
            
        }
        
    }

    
}
#pragma mark -- 标签按钮点击
- (void)markBtnClick:(WFHelperButton*)sender
{
    [self.delegate mDUsefulMarkCellMarkBtnClick:sender];
    
}



@end
