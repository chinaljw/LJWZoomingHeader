//
//  LJWZoomingHeaderControl.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "LJWZoomingHeaderControl.h"
#import "UIView+BelongController.h"

/** 默认header偏移变化速率 */
static CGFloat const DefaultFrameOffsetTrainsitionRate = 0.5f;

#define CanPerformShouldStubborn ([self.zoomingHeaderView respondsToSelector:@selector(isStubborn)])
#define CanPerformStubbornInfo ([self.zoomingHeaderView respondsToSelector:@selector(stubbornInfo)])
#define IsStubborn (CanPerformShouldStubborn && self.zoomingHeaderView.isStubborn)
#define IsStubbornAndHasStubbornInfo (IsStubborn && CanPerformStubbornInfo)


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
    
    //是否固定，调整header层级
    if (IsStubbornAndHasStubbornInfo) {
        StubbornInfo stbInfo = self.zoomingHeaderView.stubbornInfo;
        
        switch (stbInfo.hierarchy) {
            case HeaderViewHierarchyBackground:
            {
                [info.scrollView sendSubviewToBack:self.zoomingHeaderView];
            }
                break;
            case HeaderViewHierarchyFront:
            {
                [info.scrollView bringSubviewToFront:self.zoomingHeaderView];
            }
                break;
            default:
                break;
        }

    }
    
    [self resetHeightAndYWithInfo:info];
    
    [self moveToHCenterWithInfo:info];
    
    [self resetSubviews];
    
    //要放后面，不然会有惊喜~~~~
    if ([self.zoomingHeaderView respondsToSelector:@selector(maxmumHeight)]) {
        CGFloat maxHeight = [self.zoomingHeaderView maxmumHeight];
        maxHeight = maxHeight < 0.f ? 0.f : maxHeight;
        if (info.newContentOffset.y < - maxHeight) {
            info.scrollView.contentOffset = CGPointMake(0, -maxHeight);
        }
        return;
    }

}

- (void)resetHeightAndYWithInfo:(UIScrollViewScrollInfo *)info
{
    
    //纯粹为了适配automaticallyAdjustsScrollViewInsets = YES的情况
    //然而，并没有什么卵用~
    resetCount ++;
    if (info.scrollView.belongController.automaticallyAdjustsScrollViewInsets &&
        resetCount == 3)
    {
        self.zoomingHeaderView.frame = self.zoomingHeaderView.originFrame;
        return;
    }
    
    CGRect frame = self.zoomingHeaderView.frame;
    
    CGFloat change = - (info.newContentOffset.y - info.oldContentOffset.y);
    
    //得到内容往下偏移量，并矫正
    CGFloat frameOffset = [self.zoomingHeaderView respondsToSelector:@selector(frameOffset)] ? self.zoomingHeaderView.frameOffset : 0.f;
    
    [self resetValue:&frameOffset withMaximum:self.zoomingHeaderView.originFrame.size.height minimum:0.f];
    
    //如果
    frameOffset = IsStubborn ? 0.f : frameOffset;
    
    //得到变幻速率，并矫正
    CGFloat frameOffsetTrainsitionRate = [self.zoomingHeaderView respondsToSelector:@selector(frameOffsetTrainsitionRate)] ? self.zoomingHeaderView.frameOffsetTrainsitionRate : DefaultFrameOffsetTrainsitionRate;
    
    [self resetValue:&frameOffsetTrainsitionRate withMaximum:1.f minimum:0.f];
    
    //然而，并没有什么卵用~现在有卵用了~
    if (frameOffset > 0.f &&
        - info.scrollView.contentOffset.y < self.zoomingHeaderView.frame.size.height)
    {
        frame.size.height += change * frameOffsetTrainsitionRate;
        frame.size.width += change * frameOffsetTrainsitionRate;
    }
    else
    {
        frame.size.height += change;
        frame.size.width += change;
    }
    
    frame.origin.y -= change;
    
    CGFloat originHeight = self.zoomingHeaderView.originFrame.size.height;
    CGFloat originY = self.zoomingHeaderView.originFrame.origin.y;
    CGFloat originWidth = self.zoomingHeaderView.originFrame.size.width;
    
    StubbornInfo stubbornInfo = DontStubbornInfo;
    
    if (IsStubbornAndHasStubbornInfo) {
        stubbornInfo = self.zoomingHeaderView.stubbornInfo;
    }
    
    //是否往上滑
    if (info.scrollDirection == UIScrollViewScrollDirectionToTop)
    {
        //如果固定配置信息不等于不固定且类型是往上滑时固定； 且需要固定了~
        if (!stubbornInfoIsEqualToDontStubborn(stubbornInfo) && stubbornInfo.type == StubbornTypeUp && info.scrollView.contentOffset.y >= - (originHeight - stubbornInfo.y_up)) {
            CGRect stubbornFrame = self.zoomingHeaderView.frame;
            stubbornFrame.origin.y = info.scrollView.contentOffset.y - stubbornInfo.y_up;
            stubbornFrame.origin.x = 0.f;
            
            //修正size
            stubbornFrame.size.width = stubbornFrame.size.width > originWidth ? originWidth : stubbornFrame.size.width;
            stubbornFrame.size.height = stubbornFrame.size.height > originHeight ? originHeight : stubbornFrame.size.height;
            
            self.zoomingHeaderView.frame = stubbornFrame;
            return;
        }
        
        //如果算出来的大小比原始的大小小，则重置成原始的大小
        frame.origin.y = frame.origin.y >  originY ? originY : frame.origin.y;
        frame.size.height = frame.size.height < originHeight ? originHeight : frame.size.height;
        frame.size.width = frame.size.width < originWidth ? originWidth : frame.size.width;
    }
    
    //判断是否往下滑，且header是否不在屏幕中
    if (info.scrollDirection == UIScrollViewScrollDirectionToBottom &&
        info.newContentOffset.y > originY)
    {
        
        frame.origin.y = frame.origin.y <  originY ? originY : frame.origin.y;
        frame.size.height = frame.size.height > originHeight ? originHeight : frame.size.height;
        frame.size.width = frame.size.width > originWidth ? originWidth : frame.size.width;
    }
    
    //得到当前frame的偏移量，并矫正
    CGFloat currentOffset = frameOffset + (info.scrollView.contentOffset.y - originY) * frameOffsetTrainsitionRate;
    [self resetValue:&currentOffset withMaximum:frameOffset minimum:0.f];
    
    //当Header没有完全消失时，修正frame
    if (info.scrollView.contentOffset.y != self.zoomingHeaderView.frame.origin.y + currentOffset &&
        info.newContentOffset.y < originY &&
        info.newContentOffset.y < 0)
    {
        frame.origin.y = info.scrollView.contentOffset.y;
//#warning 稍等，哥哥要出去玩了，回来再搞，先这样了~
        frame.size.height = -frame.origin.y + currentOffset;
        frame.size.width = frame.size.height / originHeight * originWidth;
        frame.origin.x =  originWidth - frame.size.width;
    }

    self.zoomingHeaderView.frame = frame;
    
    info.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(frame.size.height - currentOffset, 0, 0, 0);

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

#pragma mark - Helper
- (void)resetValue:(CGFloat *)value withMaximum:(CGFloat)maximum minimum:(CGFloat)minimum
{
    *value = *value > maximum ? maximum : *value;
    *value = *value < minimum ? minimum : *value;
}

@end
