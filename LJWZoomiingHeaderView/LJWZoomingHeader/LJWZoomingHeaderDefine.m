//
//  LJWZoomingHeaderDefine.m
//  LJWZoomiingHeaderView
//
//  Created by ljw on 15/10/26.
//  Copyright © 2015年 ljw. All rights reserved.
//

#import "LJWZoomingHeaderDefine.h"

const struct StubbornInfo DontStubbornInfo = {0,0,StubbornTypeDontStubborn,HeaderViewHierarchyInTheSky};

BOOL compareStubbornInfoIsEqual(struct StubbornInfo info_1,struct StubbornInfo info_2)
{
    return info_1.y_up == info_2.y_up && info_1.y_down == info_2.y_down && info_1.type == info_2.type && info_1.hierarchy == info_2.hierarchy;
}

BOOL stubbornInfoIsEqualToDontStubborn(struct StubbornInfo info)
{
    return compareStubbornInfoIsEqual(info, DontStubbornInfo);
}