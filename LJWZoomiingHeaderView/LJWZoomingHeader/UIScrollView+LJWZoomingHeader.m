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
#import "UIView+BelongController.h"

@interface UIScrollView () <UIScrollViewContentOffsetObserverDelegate>

@property (nonatomic, strong) LJWZoomingHeaderControl *control;

@property (nonatomic, strong) NSMutableSet *keypathsBeingObserved;

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
        
//        SEL layoutSubviewsOriginSEL = @selector(layoutSubviews);
//        SEL layoutSubviewsNewSEL = @selector(ljw_contentOffsetObserver_layoutSubViews);
//        [self swizzlOriginSEL:layoutSubviewsOriginSEL newSEL:layoutSubviewsNewSEL];
        
        SEL addOriginSEL = @selector(addObserver:forKeyPath:options:context:);
        SEL addNewSEL = @selector(ljw_contentOffsetObserver_addObserver:forKeyPath:options:context:);
        [self swizzlOriginSEL:addOriginSEL newSEL:addNewSEL];
        
        SEL removeOriginSEL = @selector(removeObserver:forKeyPath:);
        SEL removeNewSEL = @selector(ljw_contentOffsetObserver_removeObserver:forKeyPath:);
        [self swizzlOriginSEL:removeOriginSEL newSEL:removeNewSEL];
        
    });
    
}

- (void)ljw_contentOffsetObserver_dealloc
{
    
    //给tableview加上headerview后再设置self.contentInsets就会野指针异常，不解。所以dealloc里就不设置了
    [self.zoomingHeaderView removeFromSuperview];
    self.zoomingHeaderView = nil;
    [self removeContentOffsetObserver];
    
    [self ljw_contentOffsetObserver_dealloc];
}

//- (void)ljw_contentOffsetObserver_layoutSubViews
//{
//    
////    [self resetZoomingHeaderViewFrame];
//    
//    [self ljw_contentOffsetObserver_layoutSubViews];
//}

- (void)ljw_contentOffsetObserver_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [self ljw_contentOffsetObserver_addObserver:observer forKeyPath:keyPath options:options context:context];
    
    [self.keypathsBeingObserved addObject:keyPath];
}

- (void)ljw_contentOffsetObserver_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    [self ljw_contentOffsetObserver_removeObserver:observer forKeyPath:keyPath];
    
    [self.keypathsBeingObserved removeObject:keyPath];
}

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
    
    [self addContentOffsetObserver];
    
}

- (void)removeZoomingHeaderView
{
    [self.zoomingHeaderView removeFromSuperview];
    self.zoomingHeaderView = nil;
    
    UIEdgeInsets insets = self.contentInset;
    insets.top = 0.f;
    [self setContentInset:insets];
    self.scrollIndicatorInsets = insets;
    
    [self removeContentOffsetObserver];
}

- (BOOL)isRegistedObserverForKeypath:(NSString *)keypath
{
    return [self.keypathsBeingObserved containsObject:keypath];
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
    
    self.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    
    self.scrollIndicatorInsets = self.contentInset;
    
    self.contentOffset = CGPointMake(self.contentOffset.x, -self.contentInset.top);
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
    [self.contentOffsetObserver releaseBindingScrollView:self];
}

@end
