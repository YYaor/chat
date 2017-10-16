//
//  PWTagsView.h
//  ThreeDimensional
//
//  Created by DFSJ on 17/2/28.
//  Copyright © 2017年 DFSJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BtnBlock)(NSInteger index);

@protocol PWTagsViewDelegate <NSObject>

- (void)getTagsViewHeight:(CGFloat)height;

@end

@interface PWTagsView : UIView

@property (nonatomic,copy) BtnBlock btnBlock;
@property (nonatomic,weak) id<PWTagsViewDelegate> delegate;

-(void)btnClickBlock:(BtnBlock) btnBlock;

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

- (void)setDataArr:(NSArray *)array;

@end
