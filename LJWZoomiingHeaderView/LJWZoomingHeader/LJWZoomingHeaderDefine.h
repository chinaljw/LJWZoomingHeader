//
//  LJWZoomingHeaderDefine.h
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/26.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

//一些方便的宏
#define CanPerformShouldStubborn(zoomingHeaderView) ([zoomingHeaderView respondsToSelector:@selector(isStubborn)])
#define CanPerformStubbornInfo(zoomingHeaderView) ([zoomingHeaderView respondsToSelector:@selector(stubbornInfo)])
#define IsStubborn(zoomingHeaderView) (CanPerformShouldStubborn(zoomingHeaderView) && zoomingHeaderView.isStubborn)
#define IsStubbornAndHasStubbornInfo(zoomingHeaderView) (IsStubborn(zoomingHeaderView) && CanPerformStubbornInfo(zoomingHeaderView))

/**
 *  顽固的类型
 */
typedef NS_ENUM(NSInteger, StubbornType){
    /**
     *  不顽固
     */
    StubbornTypeDontStubborn = 0,
    /**
     *  向上滑时固定
     */
    StubbornTypeUp = 1,
    /**
     *  向下滑时固定
     */
    StubbornTypeDown = 2,
    /**
     *  向上向下都固定
     */
    StubbornTypeUpAndDown = 3,
};

/**
 *  header的层级，在滚动时会默认把header至于对应位置
 */
typedef NS_ENUM(NSInteger, HeaderViewHierarchy){
    /**
     *  在天上
     */
    HeaderViewHierarchyInTheSky = 0,
    /**
     *  在scrollView的最前面
     */
    HeaderViewHierarchyFront = 1,
    /**
     *  在scrollView的最后面
     */
    HeaderViewHierarchyBackground = 2,
};

/**
 *  顽固配置信息结构体
 */
struct StubbornInfo
{
    /**
     *  向上固定的位置
     */
    CGFloat y_up;
    /**
     *  向下固定的位置
     */
    CGFloat y_down;
    /**
     *  固定的类型
     */
    StubbornType type;
    /**
     *  header的层级
     */
    HeaderViewHierarchy hierarchy;
};

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

/**
 *  顽固的配置信息
 */
typedef struct StubbornInfo StubbornInfo;
