//
//  MDHaveMarkCell.m
//  MyDoctor
//
//  Created by 惠生 on 17/7/12.
//  Copyright © 2017年 惠生. All rights reserved.
//

#import "MDHaveMarkCell.h"
@interface MDHaveMarkCell()

@property (weak, nonatomic) IBOutlet UIView *haveMarkView;//已有的标签

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markViewHeight;//标签View的高度


@end

@implementation MDHaveMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.markViewHeight.constant = 100.0f;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHaveMarkArr:(NSMutableArray *)haveMarkArr
{
    _haveMarkArr = haveMarkArr;
    NSLog(@"%@",haveMarkArr);
    
    for (UIView* v in self.haveMarkView.subviews) {
        [v removeFromSuperview];
    }
    if (haveMarkArr.count <= 0) {
        UILabel* label = [[UILabel alloc] init];
        label.text = @"请点击下列常用标签进行选择";
        label.textColor = [UIColor lightGrayColor];
        [self.haveMarkView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.haveMarkView.mas_centerX);
            make.centerY.equalTo(self.haveMarkView.mas_centerY);
            make.left.equalTo(self.haveMarkView.mas_left);
            make.right.equalTo(self.haveMarkView.mas_right);
        }];
        self.markViewHeight.constant = 50.0f;
    }else{
        
        
        NSInteger numRow = 1;//取行数，向上取整
        if (haveMarkArr.count >= 4) {
            numRow = (NSInteger)ceilf((float)haveMarkArr.count/4);
        }
        
        CGFloat labelWidth = (LSSCREENWIDTH - 25)/4;
        CGFloat labelHeight = labelWidth/2;
        
        self.markViewHeight.constant = numRow * labelHeight +  16;
        
        
        for (int i = 0; i < numRow; i++) {
            for(int j = 0 ;j < 4; j ++){
                UILabel* markLab = [[UILabel alloc] initWithFrame:CGRectMake((labelWidth + 5)*j , (labelHeight + 8)*i + 5, labelWidth, labelHeight)];
                
               
                markLab.textColor = BaseColor;
                markLab.textAlignment = NSTextAlignmentCenter;
                markLab.layer.masksToBounds = YES;
                markLab.layer.cornerRadius = labelHeight/2;
                markLab.layer.borderColor = BaseColor.CGColor;
                markLab.layer.borderWidth = 1.0f;
                markLab.clipsToBounds = NO;
                markLab.userInteractionEnabled = YES;
                [self.haveMarkView addSubview:markLab];
                
                WFHelperButton* deleteBtn = [[WFHelperButton alloc] init];
                [deleteBtn setBackgroundImage:[UIImage imageNamed:@"del_green_Public"] forState:UIControlStateNormal];
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [markLab addSubview:deleteBtn];
                [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(markLab.mas_right).offset(5);
                    make.top.equalTo(markLab.mas_top).offset(-labelHeight/6);
                    make.width.equalTo(@(labelHeight/2));
                    make.height.equalTo(deleteBtn.mas_width);
                    
                }];
                
                if (4 * i + j  > haveMarkArr.count -1) {
                    markLab.text = @"测试";
                }else{
                    markLab.text = haveMarkArr[4*i+j];
                    
                    deleteBtn.flagStr = haveMarkArr[4*i+j];
                }
                
                
                if (4 * i + j  > haveMarkArr.count -1) {
                    markLab.hidden = YES;
                }else{
                    markLab.hidden = NO;
                }
                
            }
            
        }
        
        
        
        
        

    }
    
    
    
    
}

#pragma mark -- 删除按钮点击
- (void)deleteBtnClick:(WFHelperButton*)sender
{
    NSLog(@"删除按钮点击%@",sender.flagStr);
    [self.delegate mDHaveMarkCellDeleteBtnClick:sender];
}

@end
