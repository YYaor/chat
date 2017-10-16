//
//  PWTagsView.m
//  ThreeDimensional
//
//  Created by DFSJ on 17/2/28.
//  Copyright © 2017年 DFSJ. All rights reserved.
//

#import "PWTagsView.h"

#define spaceW 20

@interface PWTagsView ()

@property (nonatomic,strong) NSArray *GroupArray;
@property (nonatomic,assign) NSInteger index;

@end

@implementation PWTagsView

-(instancetype) initWithFrame:(CGRect)frame delegate:(id)delegate
{
    
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
    }
    return self;
}

- (void)setDataArr:(NSArray *)array
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 15, self.frame.size.width, 1);
    view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:view];
    
    self.GroupArray = array;
    
    for (int i = 0; i < array.count; i ++)
    {
        
        NSString *name = array[i];
        
        static UIButton *recordBtn =nil;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width-4*spaceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        CGFloat BtnW = rect.size.width+2*spaceW;
        CGFloat BtnH = rect.size.height+spaceW;
        
        btn.titleLabel.numberOfLines = 0;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, spaceW, 0, spaceW);
        
        if (i == 0)
        {
            btn.frame =CGRectMake(spaceW, spaceW, BtnW, BtnH);
            
        }else{
            
            CGFloat yuWidth = self.frame.size.width - 2*spaceW -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            
            if (yuWidth >= rect.size.width) {
                
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + spaceW, recordBtn.frame.origin.y, BtnW, BtnH);
            }else{
                
                btn.frame =CGRectMake(spaceW, recordBtn.frame.origin.y+recordBtn.frame.size.height+spaceW, BtnW, BtnH);
            }
            
        }
        [btn setTitle:name forState:UIControlStateNormal];
        
        [self addSubview:btn];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width,CGRectGetMaxY(btn.frame)+spaceW);
        if ([_delegate respondsToSelector:@selector(getTagsViewHeight:)]) { // 如果协议响应了sendValue:方法
            [_delegate getTagsViewHeight:CGRectGetMaxY(btn.frame)+spaceW]; // 通知执行协议方法
        }
        
        recordBtn = btn;
        
        btn.tag = i;
        
        [btn setBackgroundColor:[UIColor colorFromHexString:LSLIGHTGRAYCOLOR]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void) BtnClick:(UIButton *)sender{
    
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.btnBlock) {
        
        weakSelf.btnBlock(sender.tag);
    }
    
}

-(void) btnClickBlock:(BtnBlock)btnBlock{
    
    self.btnBlock = btnBlock;
    
}

@end
