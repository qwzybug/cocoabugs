//
//  BPEditBitmapView.m
//  Bugpad
//
//  Created by Devin Chalmers on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BPEditBitmapView.h"


#import "PixelImage.h"

@implementation BPEditBitmapView

@synthesize bitmap;
@synthesize currentColor;

- (void)dealloc;
{
	[bitmap release], bitmap = nil;
	[currentColor release], currentColor = nil;
	
    [super dealloc];
}

- (void)setBitmap:(PixelImage *)newBitmap;
{
	if (bitmap == newBitmap)
		return;
	
	[bitmap release];
	bitmap = [newBitmap retain];
	
	self.image = bitmap.image;
	
	lastX = -1;
	lastY = -1;
	
	self.layer.magnificationFilter = kCAFilterNearest;
	self.userInteractionEnabled = YES;
}

- (void)flipPixelAtPoint:(CGPoint)pos;
{
	int x = (int)(pos.x * (float)self.bitmap.width / self.bounds.size.width);
	int y = (int)(pos.y * (float)self.bitmap.height / self.bounds.size.height);
	
	if ((lastX == x) && (lastY == y))
		return;
	
	if (!self.currentColor) {
		UIColor *color = [self.bitmap colorAtX:x y:y];
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		BOOL sample = components[0] < 0.5;
		self.currentColor = sample ? [UIColor whiteColor] : [UIColor blackColor];
	}
	
	[bitmap setColor:self.currentColor atX:x y:y];
	
	lastX = x;
	lastY = y;
	
	self.image = self.bitmap.image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
	UITouch *touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self];
	pos.y = self.bounds.size.height - pos.y; // flip coords
	
	[self flipPixelAtPoint:pos];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	UITouch *touch = [touches anyObject];
	CGPoint pos = [touch locationInView:self];
	pos.y = self.bounds.size.height - pos.y;
	
	[self flipPixelAtPoint:pos];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	self.currentColor = nil;
}

@end
