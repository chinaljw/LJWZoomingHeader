//
//  LJWZoomingHeaderViewProtocol.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJWZoomingHeaderDefine.h"

/**
 *  不顽固配置信息
 */
extern const struct StubbornInfo DontStubbornInfo;

/**
 *  比较函数
 *
 *  @param info_1 顽固配置1
 *  @param info_2 顽固配置2
 *
 *  @return 结果
 */
extern BOOL compareStubbornInfoIsEqual(struct StubbornInfo info_1,struct StubbornInfo info_2);

/**
 *  是否是不顽固配置
 *
 *  @param info 顽固配置
 *
 *  @return 结果
 */
extern BOOL stubbornInfoIsEqualToDontStubborn(struct StubbornInfo info);

@protocol LJWZoomingHeaderViewProtocol <NSObject>

/*
 用来存放初始位置、大小，的属性，必须有，其实本来也可以不必须，懒得改了~
 */
@property (nonatomic, assign) CGRect originFrame;

@optional;
/**
 在这里设置子视图的frame让他们能跟着一块儿变大变小，粗粗细细，伸伸缩缩~
 */
- (void)resetSubViewsFrame;

/**
 最大高度
 这个也不要瞎搞，嗯，你搞了也没用😏
 */
- (CGFloat)maxmumHeight;

/**
 header往下的偏移量（- -!其实是内容往上偏移的量，sorry），然而不是很完美。然而现在应该可以用了~。
 请不要给大于originFrame.size.height的值，也不要给负值，虽然你给了还是没用😏
 */
- (CGFloat)frameOffset;

/**
 当frameOffset不为0时会起作用，用以控制header偏移的速率，即frameOffset趋近于0的速率。
 不实现此代理会使用默认的速率0.5f；
 请不要给大于1.f或小于0.f的值，给了也没用😏
 */
- (CGFloat)frameOffsetTrainsitionRate;

/**
 *  是否需要固定
 *
 *  @return 是否
 */
- (BOOL)isStubborn;

/**
 *  要固定的配置信息
 *
 *  @return 要固定的配置信息
 */
- (StubbornInfo)stubbornInfo;

@end
