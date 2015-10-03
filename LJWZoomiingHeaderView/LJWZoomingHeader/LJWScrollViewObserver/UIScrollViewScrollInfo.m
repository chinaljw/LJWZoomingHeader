//
//  UIScrollViewScrollInfo.m
//  LJWScrollViewFloatingView
//
//  Created by GaoDun on 15/8/28.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIScrollViewScrollInfo.h"

@implementation UIScrollViewScrollInfo

- (instancetype)initWithChanage:(NSDictionary *)change object:(id)object
{
    self = [self init];
    
    if (self) {
        
        self.scrollView = (UIScrollView *)object;
        self.oldContentOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        self.newContentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (self.oldContentOffset.x > self.newContentOffset.x) {
            self.scrollDirection = UIScrollViewScrollDirectionToLeft;
        }
        if (self.oldContentOffset.x < self.newContentOffset.x) {
            self.scrollDirection = UIScrollViewScrollDirectionToRight;
        }
        if (self.oldContentOffset.y > self.newContentOffset.y) {
            self.scrollDirection = UIScrollViewScrollDirectionToBottom;
        }
        if (self.oldContentOffset.y < self.newContentOffset.y) {
            self.scrollDirection = UIScrollViewScrollDirectionToTop;
        }
        
        self.contentOffsetSection = CGPointMake(fabs(self.newContentOffset.x - self.oldContentOffset.x), fabs(self.newContentOffset.y - self.oldContentOffset.y));
        
    }
    
    return self;
}

@end
