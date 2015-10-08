//
//  UIScrollView+LJWZoomingHeader.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewContentOffsetObserver.h"
#import "LJWZoomingHeaderViewProtocol.h"

@interface UIScrollView (LJWZoomingHeader)

@property (nonatomic, strong, readonly) UIScrollViewContentOffsetObserver *contentOffsetObserver;

@property (nonatomic, strong, readonly) UIView<LJWZoomingHeaderViewProtocol> *zoomingHeaderView;

- (void)addZoomingHeaderView:(UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView;

- (void)removeZoomingHeaderView;

- (BOOL)isRegistedObserverForKeypath:(NSString *)keypath;

@end
