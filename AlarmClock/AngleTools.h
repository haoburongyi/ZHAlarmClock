//
//  AngleTools.h
//  AlarmClock
//
//  Created by 张淏 on 2017/10/9.
//  Copyright © 2017年 cc.umoney. All rights reserved.
//

#import <UIKit/UIKit.h>

#include <math.h>

@interface AngleTools : NSObject

/// 根据两条线算角度
+ (CGFloat)getAngleBetweenLines:(CGPoint)line1Start line1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End;

@end
