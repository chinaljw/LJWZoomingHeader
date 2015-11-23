//
//  UIView+BelongController.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/3.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "UIView+BelongController.h"

@implementation UIView (BelongController)

- (UIViewController *)belongController
{
    if ([self.nextResponder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)self.nextResponder;
    }
    else
    {
        if ([self.nextResponder isKindOfClass:[UIWindow class]]) {
            return nil;
        }
        
        return [(UIView *)self.nextResponder belongController];
    }
}

@end
