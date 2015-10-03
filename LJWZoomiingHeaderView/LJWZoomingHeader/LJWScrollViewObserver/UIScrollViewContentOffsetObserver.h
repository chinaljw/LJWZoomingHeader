//
//  UIScrollViewContentOffsetObserver.h
//  LJWScrollViewFloatingView
//
//  Created by GaoDun on 15/8/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollViewScrollInfo.h"

static NSString *const ContentOffsetKeyPath = @"contentOffset";

@class UIScrollViewContentOffsetObserver;
@protocol UIScrollViewContentOffsetObserverDelegate <NSObject>

- (void)didOffsetChangedWithScrollViewScrollInfo:(UIScrollViewScrollInfo *)info;

@end

@interface UIScrollViewContentOffsetObserver : NSObject

@property (nonatomic, weak) id<UIScrollViewContentOffsetObserverDelegate> delegate;

- (void)bindingScrollView:(UIScrollView *)scrollView;

- (void)releaseBindingScrollView:(UIScrollView *)scrollView;

@end
