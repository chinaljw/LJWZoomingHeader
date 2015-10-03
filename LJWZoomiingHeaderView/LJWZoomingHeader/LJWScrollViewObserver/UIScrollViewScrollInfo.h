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

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) UIScrollViewScrollDirection scrollDirection;

@property (nonatomic, assign) CGPoint newContentOffset;

@property (nonatomic, assign) CGPoint oldContentOffset;

@property (nonatomic, assign) CGPoint contentOffsetSection;

@property (nonatomic, weak) id<UIScrollViewContentOffsetObserverDelegate> target;

- (instancetype)initWithChanage:(NSDictionary *)change object:(id)object;

@end
