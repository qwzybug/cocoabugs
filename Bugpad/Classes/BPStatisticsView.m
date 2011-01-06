//
//  BPStatisticsView.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BPStatisticsView.h"

#import "PixelImage.h"

@implementation BPStatisticsView

@synthesize data;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
//        self.layer.geometryFlipped = YES;
    }
    return self;
}

//- (void)update;
//{
//	PixelImage *image = [[[PixelImage alloc] initWithWidth:self.frame.size.width height:self.frame.size.height] autorelease];
//	self.layer.contents = (id)image.image.CGImage;
//}

- (void)update;
{
//	float dx = self.frame.size.width / self.data.size;
//	float dy = self.frame.size.height / [self.data maxValue] / 1.25;
//	
//	PixelImage *image = [[[PixelImage alloc] initWithWidth:self.frame.size.width height:self.frame.size.height] autorelease];
//	
//	int i = 0;
//	for (NSNumber *num in data.data) {
//		int val = [num intValue];
//		if (val != 0) {
//			int x = floor(dx * i);
//			int y = floor(dy * val);
//			[image setColor:[UIColor blackColor] atX:x y:y];
//		}
//		i++;
//	}
	
//	[image.image drawInRect:self.bounds];
	self.layer.contents = (id)data.bitmap.image.CGImage;
}

- (void)dealloc {
    [super dealloc];
}


@end
