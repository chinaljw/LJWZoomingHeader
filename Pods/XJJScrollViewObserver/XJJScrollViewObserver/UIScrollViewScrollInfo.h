//
//  UIScrollViewScrollInfo.h
//  LJWScrollViewFloatingView
//
//  Created by GaoDun on 15/8/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIScrollViewScrollDirection)
{
    UIScrollViewScrollDirectionToTop = 1,
    UIScrollViewScrollDirectionToBottom = 2,
    UIScrollViewScrollDirectionToLeft = 3,
    UIScrollViewScrollDirectionToRight = 4,
    UIScrollViewScrollDirectionNone = 0,
};

@protocol  UIScrollViewContentOffsetObserverDelegate;

@interface UIScrollViewScrollInfo : NSObject

/** 正在滚动的scrollview，即被观察的scrollview */
@property (nonatomic, strong) UIScrollView *scrollingScrollView;

/** 滚动方向 */
@property (nonatomic, assign) UIScrollViewScrollDirection scrollDirection;

/** 新的offset */
@property (nonatomic, assign) CGPoint newContentOffset;

/** 旧的offset */
@property (nonatomic, assign) CGPoint oldContentOffset;

/** 滚动距离 */
@property (nonatomic, assign) CGPoint contentOffsetSection;

/** 目标对象,即scrollViewObserver的代理 */
@property (nonatomic, weak) id<UIScrollViewContentOffsetObserverDelegate> target;

/** 便捷初始化方法 */
- (instancetype)initWithChanage:(NSDictionary *)change
            scrollingScrollView:(UIScrollView *)scrollingScrollView
                         target:(id<UIScrollViewContentOffsetObserverDelegate>)target;
@end
