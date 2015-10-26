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

#pragma mark Protocol 这里都是可选的
//在这里设置子视图的frame让他们能跟着一块儿变大变小，粗粗细细，伸伸缩缩~
- (void)resetSubViewsFrame
{
    self.centerView.frame = CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height / 3);
    self.centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.imageView.frame = self.bounds;
}

//header最大的高度
- (CGFloat)maxmumHeight
{
    return 450.f;
}

//header往下的偏移量，然而不是很完美，然而现在应该可以用了~。
- (CGFloat)frameOffset
{
    return 50.f;
}

- (CGFloat)frameOffsetTrainsitionRate
{
    return 0.5f;
}

/**
 *  是否需要固定
 *
 *  @return 是否
 */
- (BOOL)isStubborn
{
    return YES;
}

/**
 *  要固定的配置信息
 *
 *  @return 要固定的配置信息
 */
- (StubbornInfo)stubbornInfo
{
    StubbornInfo info = {250.f,150.f, StubbornTypeUp, HeaderViewHierarchyFront};
    return info;
}

@end
