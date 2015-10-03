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

@property (nonatomic, assign) CGRect originFrame;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *imageView;

@end
