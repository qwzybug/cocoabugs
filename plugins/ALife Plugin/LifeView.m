//
//  LifeView.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LifeView.h"

#import "LifeModel.h"

@implementation LifeView

- (id)initWithFrame:(NSRect)frame;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing LifeView");
	[simulation release];
	
	[super dealloc];
}

- (void)setSimulation:(LifeModel *)theSimulation;
{
	[simulation release];
	simulation = [theSimulation retain];
}

- (void)drawRect:(NSRect)rect;
{
	if (!simulation)
		return;
	
//	[[NSColor redColor] set];
//	[[NSBezierPath bezierPathWithOvalInRect:[self bounds]] fill];
	
	[[NSColor blueColor] set];
	[[NSString stringWithFormat:@"%d", simulation.generation] drawInRect:[self bounds]
														  withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor blueColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:48.0], NSFontAttributeName, nil]];
}

@end
