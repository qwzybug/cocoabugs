//
//  UIColor+HSVSquare.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "UIColor+HSVSquare.h"


@implementation UIColor (HSVSquare)

+ (UIColor *)colorForPoint:(CGPoint)point;
{
	float hue;
	float x = point.x;
	float y = point.y;
	// hooray magic numbers!
	if (x > 0) {
		if (y > 0) {
			hue = 0.125;
		} else if (y < 0) {
			hue = 0.875;
		} else {
			hue = 0.0;
		}
	} else if (x < 0) {
		if (y > 0) {
			hue = 0.375;
		} else if (y < 0) {
			hue = 0.625;
		} else {
			hue = 0.5;
		}
	} else {
		if (y > 0) {
			hue = 0.25;
		} else if (y < 0) {
			hue = 0.75;
		} else {
			hue = 0.0;
		}
	}
	
	return [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
}

+ (UIColor *)colorForPoint:(CGPoint)point maxMagnitude:(float)magnitude;
{
	return [self colorForPoint:point];
}

@end
