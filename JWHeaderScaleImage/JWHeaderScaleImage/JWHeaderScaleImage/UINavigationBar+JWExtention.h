//
//  UINavigationBar+JWExtention.h
//  JWHeaderScaleImage
//
//  Created by evenCoder on 16/8/18.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (JWExtention)

/**
 *  设置导航条背景颜色
 */
- (void)jw_setBackgroundColor:(UIColor *)backgroundColor;

/**
 *  设置透明度
 */
- (void)jw_setElementsAlpha:(CGFloat)alpha;

/**
 *  设置导航栏Y轴
 */
- (void)jw_setTranslationY:(CGFloat)translationY;

/**
 *  重置
 */
- (void)jw_reset;



@end
