//
//  UIColor+HSVSquare.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (HSVSquare)

+ (UIColor *)colorForPoint:(CGPoint)point;
+ (UIColor *)colorForPoint:(CGPoint)point maxMagnitude:(float)magnitude;

@end
