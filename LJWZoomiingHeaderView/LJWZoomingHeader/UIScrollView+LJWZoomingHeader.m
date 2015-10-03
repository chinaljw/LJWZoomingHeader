//
//  UIScrollView+LJWZoomingHeader.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIScrollView+LJWZoomingHeader.h"
#import <objc/runtime.h>
#import "LJWZoomingHeaderControl.h"

@interface UIScrollView () <UIScrollViewContentOffsetObserverDelegate>

@property (nonatomic, strong) LJWZoomingHeaderControl *control;

@end

@implementation UIScrollView (LJWZoomingHeader)

#pragma mark - MethodSwizzling
+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL deallocOriginSEL = NSSelectorFromString(@"dealloc");
        SEL deallocNewSEL = @selector(ljw_contentOffsetObserver_dealloc);
        [self swizzlOriginSEL:deallocOriginSEL newSEL:deallocNewSEL];
        
//        SEL layoutSubviewsOriginSEL = @selector(didMoveToSuperview);
//        SEL layoutSubviewsNewSEL = @selector(ljw_contentOffsetObserver_layoutSubViews);
//        [self swizzlOriginSEL:layoutSubviewsOriginSEL newSEL:layoutSubviewsNewSEL];
        
    });
    
}

- (void)ljw_contentOffsetObserver_dealloc
{
    [self removeZoomingHeaderView];
    
    [self ljw_contentOffsetObserver_dealloc];
}

//- (void)ljw_contentOffsetObserver_layoutSubViews
//{
//    
//    [self resetZoomingHeaderViewFrame];
//    
//    [self ljw_contentOffsetObserver_layoutSubViews];
//}

+ (void)swizzlOriginSEL:(SEL)originSEL newSEL:(SEL)newSEL
{
    Method originMethod = class_getInstanceMethod(self.class, originSEL);
    Method newMethod = class_getInstanceMethod(self.class, newSEL);
    
    if (class_addMethod(self.class, originSEL, method_getImplementation(newMethod), method_getTypeEncoding(originMethod))) {
        class_replaceMethod(self.class, newSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else
    {
        method_exchangeImplementations(originMethod, newMethod);
    }

}

#pragma mark - Setter & Getter
- (void)setContentOffsetObserver:(UIScrollViewContentOffsetObserver *)contentOffsetObserver
{
    objc_setAssociatedObject(self, @selector(contentOffsetObserver), contentOffsetObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollViewContentOffsetObserver *)contentOffsetObserver
{
    return objc_getAssociatedObject(self, _cmd);
}

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

#pragma mark - Control
- (void)addZoomingHeaderView:(UIView<LJWZoomingHeaderViewProtocol> *)zoomingHeaderView
{
    
    [self.zoomingHeaderView removeFromSuperview];
    
    self.zoomingHeaderView = zoomingHeaderView;
    
    [self addSubview:self.zoomingHeaderView];
    
    [self sendSubviewToBack:self.zoomingHeaderView];
    
    [self resetZoomingHeaderViewFrameAndSelfInset];
    
    [self addControl];
    
    [self addContentOffsetObserver];
    
}

- (void)removeZoomingHeaderView
{
    [self.zoomingHeaderView removeFromSuperview];
    self.zoomingHeaderView = nil;
    [self removeContentOffsetObserver];
}

#pragma mark - Helper
- (void)resetZoomingHeaderViewFrameAndSelfInset
{
    
    CGFloat offset = [self.zoomingHeaderView respondsToSelector:@selector(frameOffset)] ? self.zoomingHeaderView.frameOffset : 0;
    
    CGRect frame = self.zoomingHeaderView.frame;
    frame.origin.x = 0;
    frame.origin.y = - frame.size.height + offset;
//    frame.size.width = self.frame.size.width;
    self.zoomingHeaderView.frame = frame;
    self.zoomingHeaderView.originFrame = frame;
    
    self.contentInset = UIEdgeInsetsMake(self.zoomingHeaderView.originFrame.size.height - offset, 0, 0, 0);
    
}

- (void)addControl
{
    LJWZoomingHeaderControl *control = [[LJWZoomingHeaderControl alloc] init];
    control.zoomingHeaderView = self.zoomingHeaderView;
    self.control = control;
}

#pragma mark - Observer
- (void)addContentOffsetObserver
{
    self.contentOffsetObserver = [[UIScrollViewContentOffsetObserver alloc] init];
    self.contentOffsetObserver.delegate = self.control;
    
    [self.contentOffsetObserver bindingScrollView:self];
}

- (void)removeContentOffsetObserver
{
    [self.contentOffsetObserver releaseBindingScrollView];
    self.contentOffsetObserver = nil;
}

@end
