//
//  UIScrollView+HeaderScaleImage.m
//  JWHeaderScaleImage
//
//  Created by evenCoder on 16/8/17.
//  Copyright © 2016年 evenCoder. All rights reserved.
//

#import "UIScrollView+HeaderScaleImage.h"
#import <objc/runtime.h>

#define JWKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))

/**
 *  分类的目的: 实现两个方法实现交换，调用原有方法，有先有方法(自己实现)实现
 */
@interface NSObject (MethodSwipping)

/**
 *  交换对象方法
 *
 *  @param origSelector 原有方法
 *  @param swipSelector 现有方法(自己实现方法)
 */
+ (void)jw_swipInstanceSelector:(SEL)origSelector
                   swipSelector:(SEL)swipSelector;

/**
 *  交换类方法
 *
 *  @param origSelector 原有方法
 *  @param swipSelector 现有方法(自己实现)
 */
+ (void)jw_swipClassSelector:(SEL)origSelector
                swipSelector:(SEL)swipSelector;

@end

@implementation NSObject (MethodSwipping)

+ (void)jw_swipInstanceSelector:(SEL)origSelector swipSelector:(SEL)swipSelector {
    
    // 获取原有方法
    Method origMethod = class_getInstanceMethod(self, origSelector);
    
    // 获取交换方法
    Method swipMethod = class_getInstanceMethod(self, swipSelector);
    
    /**
     * 注意: 不能直接交换方法实现，需要判断原有方法是否存在，存在才交换
     * 如何判断? 添加原有方法，如果成功，表示原有方法不存在；失败，则表示原有方法存在
     * 原有方法可能没有实现，所以这里添加方法实现，用自己方法实现
     * 这样做的好处:方法不存在，直接把自己方法的实现作为原有方法的实现，调用原有放来当前方法实现
     */
    
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swipMethod), method_getTypeEncoding(swipMethod));
    
    if (!isAdd) { // 表示原有方法存在 直接替换
        
        method_exchangeImplementations(origMethod, swipMethod);
    }
    
}

+ (void)jw_swipClassSelector:(SEL)origSelector swipSelector:(SEL)swipSelector {
    
    // 获取原有方法
    Method origMethod = class_getClassMethod(self, origSelector);
    
    // 获取交换方法
    Method swipMethod = class_getClassMethod(self, swipSelector);
    
    // 添加原有方法实现为当前方法实现
    
    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swipMethod), method_getTypeEncoding(swipMethod));
    if (!isAdd) {
        
        method_exchangeImplementations(origMethod, swipMethod);
    }
}

@end

static char * const headerImageViewKey = "headerImageViewKey";
static char * const headerImageViewHeight = "headerImageViewHeight";
static char * const isInitialKey = "isInitialKey";

// 默认高度
static CGFloat const origImageHeight = 200;

@implementation UIScrollView (HeaderScaleImage)

+ (void)load {
    
    [self jw_swipInstanceSelector:@selector(setTableHeaderView:) swipSelector:@selector(setJw_TableHeaderView:)];
}

- (void)setJw_TableHeaderView:(UIView *)tableHeaderView {
    
    // 不是tableView 就不需要做下面的事情
    if (![self isMemberOfClass:[UITableView class]]) {
        
        return;
    }
    
    // 设置tableView头部视图
    [self setJw_TableHeaderView:tableHeaderView];
    
    // 设置头部视图的位置
    UITableView *tableView = (UITableView *)self;
    
    self.jw_headerScaleImageHeight = tableView.tableHeaderView.frame.size.height;
}

/**
 *  懒加载头部imageView
 */
- (UIImageView *)jw_headerImageView {
    
    UIImageView *imageView = objc_getAssociatedObject(self, headerImageViewKey);
    
    if (imageView == nil) {
        
        imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self insertSubview:imageView atIndex:0];
        
        // 保存imageView
        objc_setAssociatedObject(self, headerImageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageView;
}

/**
 *  属性: jw_isInitial
 */
- (BOOL)jw_isInitial {
    
    return [objc_getAssociatedObject(self, isInitialKey) boolValue];
}

- (void)setJw_isInitial:(BOOL)jw_isInitial {
    
    objc_setAssociatedObject(self, isInitialKey, @(jw_isInitial), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  属性:yz_headerImageViewHeight
 */
- (void)setJw_headerScaleImageHeight:(CGFloat)jw_headerScaleImageHeight {
    
    objc_setAssociatedObject(self, headerImageViewHeight, @(jw_headerScaleImageHeight), OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 设置头部视图位置
    [self setupHeaderImageViewFrame];
}

- (CGFloat)jw_headerScaleImageHeight {
    
    CGFloat headerImageHeight = [objc_getAssociatedObject(self, headerImageViewHeight) floatValue];
    return headerImageHeight == 0 ? origImageHeight : headerImageHeight;
}

/**
 *  属性: jw_headerImage
 */
- (UIImage *)jw_headerScaleImage {
    
    return self.jw_headerImageView.image;
}

/**
 *  设置头部imageView的图片
 */
- (void)setJw_headerScaleImage:(UIImage *)jw_headerScaleImage {
    
    self.jw_headerImageView.image = jw_headerScaleImage;
    
    // 初始化头部视图
    [self setupHeaderImageView];
}

/**
 *  设置头部视图位置
 */
- (void)setupHeaderImageViewFrame {
    
    self.jw_headerImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.jw_headerScaleImageHeight);
}

/**
 *  初始化头部视图
 */
- (void)setupHeaderImageView {
    
    // 设置头部视图的位置
    [self setupHeaderImageViewFrame];
    
    // KVO监听偏移量，修改头部imageView的frame
    if (self.jw_isInitial == NO) {
        
        [self addObserver:self forKeyPath:JWKeyPath(self, contentOffset) options:NSKeyValueObservingOptionNew context:nil];
        self.jw_isInitial = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // 获取当前偏移量
    CGFloat offsetY = self.contentOffset.y;
    
    if (offsetY < 0) {
        
        self.jw_headerImageView.frame = CGRectMake(offsetY, offsetY, self.bounds.size.width - offsetY * 2, self.jw_headerScaleImageHeight - offsetY);
    }
    else {
        
        self.jw_headerImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.jw_headerScaleImageHeight);
    }
}

- (void)dealloc {
    
    if (self.jw_isInitial) {
        
        [self removeObserver:self forKeyPath:JWKeyPath(self, contentOffset)];
    }
}
@end






















