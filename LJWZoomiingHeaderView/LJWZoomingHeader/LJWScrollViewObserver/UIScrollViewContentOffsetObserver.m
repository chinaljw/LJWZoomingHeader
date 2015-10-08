//
//  UIScrollViewContentOffsetObserver.m
//  LJWScrollViewFloatingView
//
//  Created by GaoDun on 15/8/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIScrollViewContentOffsetObserver.h"
#import "UIScrollView+LJWZoomingHeader.h"

@implementation UIScrollViewContentOffsetObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:ContentOffsetKeyPath]) {
        
//        NSLog(@"change == %@ \n object == %@", change, object);
        
        UIScrollViewScrollInfo *info = [[UIScrollViewScrollInfo alloc] initWithChanage:change object:object];
        info.target = self.delegate;
        
        [self.delegate didOffsetChangedWithScrollViewScrollInfo:info];
        
    }
}

- (void)bindingScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isRegistedObserverForKeypath:ContentOffsetKeyPath]) {
        [scrollView removeObserver:self forKeyPath:ContentOffsetKeyPath];
    }
    [scrollView addObserver:self forKeyPath:ContentOffsetKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)releaseBindingScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isRegistedObserverForKeypath:ContentOffsetKeyPath]) {
        [scrollView removeObserver:self forKeyPath:ContentOffsetKeyPath];
    }
}

- (void)dealloc
{
//    NSLog(@"dealloc %@", self);
}

@end
