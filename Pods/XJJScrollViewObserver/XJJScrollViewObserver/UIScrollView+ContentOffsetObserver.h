//
//  UIScrollVIew+ContentOffsetObserver.h
//  LJWZoomiingHeaderView
//
//  Created by GaoDun on 15/10/12.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollViewContentOffsetObserver.h"

/*
 直接scrollView.contentOffsetObserver就能用了
 */

@interface UIScrollView (ContentOffsetObserver)

@property (nonatomic, strong, readonly) UIScrollViewContentOffsetObserver *contentOffsetObserver;

@end
