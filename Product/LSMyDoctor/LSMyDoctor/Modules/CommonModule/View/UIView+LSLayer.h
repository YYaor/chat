//
//  UIView+LSLayer.h
//  LSMyDoctor
//
//  Created by 赵炯丞 on 2017/9/27.
//  Copyright © 2017年 赵炯丞. All rights reserved.
//

#import <UIKit/UIKit.h>

//在定义类的前面加上IB_DESIGNABLE宏
/**
 * 这个宏定义的作用是可以通过keypath动态看到效果,实时性,不过还是需要通过在keypath中输入相关属性来设置
 */
IB_DESIGNABLE  //动态刷新

@interface UIView (LSLayer)

//注意:加上IBInspectable就可以可视化显示相关的属性
/**
 * 可视化设置边框宽度
 */
@property (nonatomic,assign)IBInspectable CGFloat borderWidth;

/**
 * 可视化设置边框颜色
 */
@property (nonatomic,strong)IBInspectable UIColor *borderColor;

/**
 * 可视化设置圆角
 */
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;

@end
