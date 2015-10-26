//
//  LJWZoomingHeaderViewProtocol.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/2.
//  Copyright (c) 2015年 ljw. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, StubbornType)
{
    StubbornTypeDontStubborn = 0,
    StubbornTypeUp = 1,
    StubbornTypeDown = 2,
    StubbornTypeUpAndDown = 3,
};

typedef NS_ENUM(NSInteger, HeaderViewHierarchy)
{
    HeaderViewHierarchyInTheSky = 0,
    HeaderViewHierarchyFront = 1,
    HeaderViewHierarchyBackground = 2,
};

struct StubbornInfo
{
    CGFloat y_up;
    CGFloat y_down;
    StubbornType type;
    HeaderViewHierarchy hierarchy;
};

//不固定配置信息
static const struct StubbornInfo DontStubbornInfo = {0,0,StubbornTypeDontStubborn,HeaderViewHierarchyInTheSky};

static BOOL compareStubbornInfoIsEqual(struct StubbornInfo info_1,struct StubbornInfo info_2)
{
    return info_1.y_up == info_2.y_up && info_1.y_down == info_2.y_down && info_1.type == info_2.type && info_1.hierarchy == info_2.hierarchy;
}

static BOOL stubbornInfoIsEqualToDontStubborn(struct StubbornInfo info)
{
    return compareStubbornInfoIsEqual(info, DontStubbornInfo);
}

//要固定的位置
typedef struct StubbornInfo StubbornInfo;

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
