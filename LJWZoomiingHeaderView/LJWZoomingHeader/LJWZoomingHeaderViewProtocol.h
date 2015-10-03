//
//  LJWZoomingHeaderViewProtocol.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJWZoomingHeaderViewProtocol <NSObject>

@property (nonatomic, assign) CGRect originFrame;

@optional;
- (void)resetSubViewsFrame;

- (CGFloat)maxHeight;

- (CGFloat)frameOffset;

@end
