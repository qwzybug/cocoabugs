//
//  LifeView.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DaisyWorldView.h"

#import "DaisyWorld.h"
#import "DaisyCell.h"
#import "Daisy.h"

@implementation DaisyWorldView

- (id)initWithFrame:(NSRect)frame;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing DaisyWorldView");
	[simulation release];
	
	[super dealloc];
}

- (void)setSimulation:(DaisyWorld *)theSimulation;
{
	[simulation release];
	simulation = [theSimulation retain];
}

- (void)drawRect:(NSRect)rect;
{
	if (!simulation)
		return;
	
	NSLog(@"Drawing!");
	
	NSBezierPath *whiteDaisies = [NSBezierPath bezierPath];
	NSBezierPath *blackDaisies = [NSBezierPath bezierPath];
	
//	[[NSColor redColor] set];
//	[[NSBezierPath bezierPathWithOvalInRect:[self bounds]] fill];
	NSSize dimensions = NSMakeSize(self.frame.size.width / [simulation.terrain count],
								   self.frame.size.height / [simulation.terrain count]);
	
	int i, j;
	NSMutableArray *row;
	DaisyCell *cell;
	for (i = 0; i < [simulation.terrain count]; i++) {
		row = [simulation.terrain objectAtIndex:i];
		for (j = 0; j < [row count]; j++) {
			cell = [row objectAtIndex:j];
			NSPoint position = NSMakePoint(i * dimensions.width, j * dimensions.height);
			// fill background
			NSRect cellRect = NSMakeRect(position.x, position.y, dimensions.width, dimensions.height);
			[[NSColor colorWithDeviceWhite:cell.temperature alpha:1.0] set];
			NSRectFill(cellRect);
			// add daisy to path
			if (cell.daisy) {
				NSBezierPath *daisyPath = [NSBezierPath bezierPathWithOvalInRect:cellRect];
				if (cell.daisy.type == WHITE_DAISY) {
					[whiteDaisies appendBezierPath:daisyPath];
				} else {
					[blackDaisies appendBezierPath:daisyPath];
				}
			}
		}
	}
	
	[[NSColor whiteColor] set];
	[whiteDaisies fill];
	
	[[NSColor blackColor] set];
	[blackDaisies fill];
	
//	[[NSColor blueColor] set];
//	[[NSString stringWithFormat:@"%d", simulation.generation] drawInRect:[self bounds]
//														  withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor blueColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:48.0], NSFontAttributeName, nil]];
}

@end
