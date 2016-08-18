//
//  UIScrollView+HeaderScaleImage.h
//  JWHeaderScaleImage
//
//  Created by evenCoder on 16/8/17.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HeaderScaleImage)

/** 头部缩放视图图片 */
@property (nonatomic, strong) UIImage *jw_headerScaleImage;

/** 缩放视图高度 */
@property (nonatomic, assign) CGFloat jw_headerScaleImageHeight;

@end
