//
//  LJWZoomingHeaderControl.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "LJWZoomingHeaderControl.h"
#import "UIView+BelongController.h"

@interface LJWZoomingHeaderControl ()
{
    //resetFrame的次数
    NSUInteger resetCount;
}

@end

@implementation LJWZoomingHeaderControl

#pragma mark -
- (void)didOffsetChangedWithScrollViewScrollInfo:(UIScrollViewScrollInfo *)info
{
    
//    NSLog(@"%lf", info.scrollView.contentOffset.y);
    
    //是否往上滑动
//    if (info.scrollView.contentOffset.y > - self.zoomingHeaderView.originFrame.size.height) {
//        //是否和原始大小一样，不一样重置
//        if (self.zoomingHeaderView.frame.size.height != self.zoomingHeaderView.originFrame.size.height) {
////            [UIView animateWithDuration:.1f animations:^{
//                self.zoomingHeaderView.frame = self.zoomingHeaderView.originFrame;
//                [self moveToHCenterWithInfo:info];
//                [self resetSubviews];
////            } completion:^(BOOL finished) {
////                
////            }];
//        }
//        return;
//    }
    
    if ([self.zoomingHeaderView respondsToSelector:@selector(maxHeight)]) {
        CGFloat maxHeight = [self.zoomingHeaderView maxHeight];
        if (info.newContentOffset.y < - maxHeight) {
            info.scrollView.contentOffset = CGPointMake(0, -maxHeight);
        }
    }
    
    [self resetHeightAndYWithInfo:info];
    
    [self moveToHCenterWithInfo:info];
    
    [self resetSubviews];

}

- (void)resetHeightAndYWithInfo:(UIScrollViewScrollInfo *)info
{
    
    //纯粹为了适配automaticallyAdjustsScrollViewInsets = YES的情况
    resetCount ++;
    if (info.scrollView.belongController.automaticallyAdjustsScrollViewInsets && resetCount == 3) {
        self.zoomingHeaderView.frame = self.zoomingHeaderView.originFrame;
        return;
    }
    
    CGRect frame = self.zoomingHeaderView.frame;
    CGFloat change = - (info.newContentOffset.y - info.oldContentOffset.y);
    frame.size.height += change;
    frame.size.width += change;
    
    frame.origin.y -= change;
    
    CGFloat originHeight = self.zoomingHeaderView.originFrame.size.height;
    CGFloat originY = self.zoomingHeaderView.originFrame.origin.y;
    CGFloat originWidth = self.zoomingHeaderView.originFrame.size.width;
    
    
    //是否往上滑
    if (info.scrollDirection == UIScrollViewScrollDirectionToTop) {
        
        //如果算出来的大小比原始的大小小，则重置成原始的大小
        frame.origin.y = frame.origin.y >  originY ? originY : frame.origin.y;
        frame.size.height = frame.size.height < originHeight ? originHeight : frame.size.height;
        frame.size.width = frame.size.width < originWidth ? originWidth : frame.size.width;
    }
    
    //判断是否往下滑，且header是否不在屏幕中
    if (info.scrollDirection == UIScrollViewScrollDirectionToBottom && info.newContentOffset.y > originY) {
        frame.origin.y = frame.origin.y <  originY ? originY : frame.origin.y;
        frame.size.height = frame.size.height > originHeight ? originHeight : frame.size.height;
        frame.size.width = frame.size.width > originWidth ? originWidth : frame.size.width;
    }
    
    //当Header没有完全消失时，修正frame
    if (info.scrollView.contentOffset.y != self.zoomingHeaderView.frame.origin.y && info.newContentOffset.y < originY && info.newContentOffset.y < 0) {
        
        frame.origin.y = info.scrollView.contentOffset.y;
        frame.size.height = -frame.origin.y;
        frame.size.width = frame.size.height / originHeight * originWidth;
        frame.origin.x =  originWidth - frame.size.width;
        
    }

    
    self.zoomingHeaderView.frame = frame;
    
//    NSLog(@"%@", NSStringFromCGRect(frame));
    
    info.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(frame.size.height, 0, 0, 0);

}

- (void)moveToHCenterWithInfo:(UIScrollViewScrollInfo *)info
{
    CGPoint center = self.zoomingHeaderView.center;
    center.x = info.scrollView.frame.size.width / 2;
    self.zoomingHeaderView.center = center;
}

- (void)resetSubviews
{
    if ([self.zoomingHeaderView respondsToSelector:@selector(resetSubViewsFrame)]) {
        [self.zoomingHeaderView resetSubViewsFrame];
    }
}

@end
