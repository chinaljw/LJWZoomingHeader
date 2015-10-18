//
//  UIScrollVIew+ContentOffsetObserver.m
//  LJWZoomiingHeaderView
//
//  Created by GaoDun on 15/10/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIScrollView+ContentOffsetObserver.h"
#import <objc/runtime.h>

@implementation UIScrollView (ContentOffsetObserver)

- (void)setContentOffsetObserver:(UIScrollViewContentOffsetObserver *)contentOffsetObserver
{
    objc_setAssociatedObject(self, @selector(contentOffsetObserver), contentOffsetObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollViewContentOffsetObserver *)contentOffsetObserver
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)addContentOffsetObserver:(UIScrollViewContentOffsetObserver *)observer
{
    
    if (self.contentOffsetObserver) {
        [self removeContentOffsetObserver:self.contentOffsetObserver];
    }
    
    self.contentOffsetObserver = observer;
    
    [self addObserver:self.contentOffsetObserver forKeyPath:ContentOffsetKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)removeContentOffsetObserver:(UIScrollViewContentOffsetObserver *)observer
{
    
    if (self.contentOffsetObserver && self.contentOffsetObserver == observer) {
        [self removeObserver:self.contentOffsetObserver forKeyPath:ContentOffsetKeyPath];
        self.contentOffsetObserver = nil;
    }
    
}

@end
