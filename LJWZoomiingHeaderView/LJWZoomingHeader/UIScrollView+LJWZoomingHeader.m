//
//  UIScrollView+LJWZoomingHeader.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIScrollView+LJWZoomingHeader.h"
#import <objc/runtime.h>


@interface UIScrollView () <UIScrollViewContentOffsetObserverDelegate>

@property (nonatomic, strong) LJWZoomingHeaderControl *control;

@property (nonatomic, strong) NSMutableSet *keypathsBeingObserved;

@end

@implementation UIScrollView (LJWZoomingHeader)

#pragma mark - Setter & Getter
- (void)setZoomingHeaderView:(UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView
{
    objc_setAssociatedObject(self, @selector(zoomingHeaderView), zoomingHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setControl:(LJWZoomingHeaderControl *)control
{
    objc_setAssociatedObject(self, @selector(control), control, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LJWZoomingHeaderControl *)control
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSMutableArray *)keypathsBeingObserved
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        self.keypathsBeingObserved = [[NSMutableSet alloc] init];
    }

    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeypathsBeingObserved:(NSMutableArray *)keypathsBeingObserved
{
    objc_setAssociatedObject(self, @selector(keypathsBeingObserved), keypathsBeingObserved, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Control
- (void)addZoomingHeaderView:(UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView
{
    
    [self.zoomingHeaderView removeFromSuperview];
    
    self.zoomingHeaderView = zoomingHeaderView;
    
    [self addSubview:self.zoomingHeaderView];
    
    [self sendSubviewToBack:self.zoomingHeaderView];
    
    [self resetZoomingHeaderViewFrameAndSelfInset];
    
    [self addControl];
    
}

- (void)removeZoomingHeaderView
{
    [self.zoomingHeaderView removeFromSuperview];
    self.zoomingHeaderView = nil;
    
    UIEdgeInsets insets = self.contentInset;
    insets.top = 0.f;
    [self setContentInset:insets];
    self.scrollIndicatorInsets = insets;
    
    [self.contentOffsetObserver removeDelegate:self.control];
}

#pragma mark - Helper
- (void)resetZoomingHeaderViewFrameAndSelfInset
{
    [self resetZoomingHeaderViewFrame];
    
    [self resetContentInset];
}

- (void)resetZoomingHeaderViewFrame
{
    CGFloat offset = [self.zoomingHeaderView respondsToSelector:@selector(frameOffset)] ? self.zoomingHeaderView.frameOffset : 0;
    
    //如果是个顽固的header那就忽略frameOffset
    if (IsStubbornAndHasStubbornInfo(self.zoomingHeaderView) && !stubbornInfoIsEqualToDontStubborn(self.zoomingHeaderView.stubbornInfo)) {
        offset = 0.f;
    }
    
    CGRect frame = self.zoomingHeaderView.frame;
    frame.origin.x = 0;
    frame.origin.y = - frame.size.height + offset;
    //    frame.size.width = self.frame.size.width;
    self.zoomingHeaderView.frame = frame;
    self.zoomingHeaderView.originFrame = frame;
}

- (void)resetContentInset
{
    CGFloat topInset = - self.zoomingHeaderView.originFrame.origin.y;
    
    //调整inset，然而并没有什么卵用。
    if (self.belongController.automaticallyAdjustsScrollViewInsets) {
        topInset -= 64.f;
    }
    
    UIEdgeInsets inset = self.contentInset;
    inset.top = topInset;
    self.contentInset = inset;
    
    self.scrollIndicatorInsets = self.contentInset;
    
    self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
}

- (void)addControl
{
    LJWZoomingHeaderControl *control = [[LJWZoomingHeaderControl alloc] init];
    control.zoomingHeaderView = self.zoomingHeaderView;
    self.control = control;
    [self.contentOffsetObserver addDelegate:self.control];
}

@end
