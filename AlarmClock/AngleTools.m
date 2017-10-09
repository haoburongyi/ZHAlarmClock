//
//  AngleTools.m
//  AlarmClock
//
//  Created by 张淏 on 2017/10/9.
//  Copyright © 2017年 cc.umoney. All rights reserved.
//

#import "AngleTools.h"

@implementation AngleTools

#define pi 3.14159265358979323846
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return radiansToDegrees(rads);
    //degs = degrees(atan((top - bottom)/(right - left)))
}

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return radiansToDegrees(rads);
    
}

+ (CGFloat)getAngleBetweenLines:(CGPoint)line1Start line1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End {
    return angleBetweenLines(line1Start, line1End, line2Start, line2End);
}

@end
