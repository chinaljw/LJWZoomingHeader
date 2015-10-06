//
//  TestZoomingHeaderView.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJWZoomingHeaderViewProtocol.h"

@interface TestZoomingHeaderView : UIView <LJWZoomingHeaderViewProtocol>

//用来存放初始位置、大小，的属性，必须有，其实本来也可以不必须，懒得改了~
@property (nonatomic, assign) CGRect originFrame;

//随你怎么搞了~
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *imageView;

@end
