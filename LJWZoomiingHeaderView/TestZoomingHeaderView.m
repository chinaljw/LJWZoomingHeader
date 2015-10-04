//
//  TestZoomingHeaderView.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import "TestZoomingHeaderView.h"

@implementation TestZoomingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.centerView];
        [self resetSubViewsFrame];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

#pragma mark - Setter & Getter
- (UIView *)centerView
{
    
    if (!_centerView) {
        
        _centerView = [[UIView alloc] initWithFrame:CGRectZero];
        _centerView.backgroundColor = [UIColor grayColor];
        
    }
    
    return _centerView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"7494e68agb7a98471e34f&690.jpg"]];
    }
    return _imageView;
}

#pragma mark Protocol
- (void)resetSubViewsFrame
{
    self.centerView.frame = CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height / 3);
    self.centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.imageView.frame = self.bounds;
}

//- (CGFloat)maxHeight
//{
//    return 1000.f;
//}

- (CGFloat)frameOffset
{
    return 0.f;
}

@end
