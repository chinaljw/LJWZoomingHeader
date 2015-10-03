//
//  LJWZoomingHeaderControl.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollViewContentOffsetObserver.h"
#import "LJWZoomingHeaderViewProtocol.h"

@interface LJWZoomingHeaderControl : NSObject <UIScrollViewContentOffsetObserverDelegate>

@property (nonatomic, strong) UIView<LJWZoomingHeaderViewProtocol> *zoomingHeaderView;

@end
