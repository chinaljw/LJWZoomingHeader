//
//  UIScrollView+LJWZoomingHeader.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJWZoomingHeaderControl.h"
#import "UIView+BelongController.h"
#import "UIScrollView+ContentOffsetObserver.h"

@interface UIScrollView (LJWZoomingHeader)

@property (nonatomic, strong, readonly) UIView<LJWZoomingHeaderViewProtocol> *zoomingHeaderView;

- (void)addZoomingHeaderView:(UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView;

- (void)removeZoomingHeaderView;

@end
