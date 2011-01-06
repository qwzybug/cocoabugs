//
//  LifeView.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LifeView.h"

#import "ALifeSimulation.h"
#import "ALifeCritter.h"

@implementation LifeView

@synthesize simulation;

- (void)drawRect:(CGRect)rect {
    float dx = self.bounds.size.width / simulation.width;
	float dy = self.bounds.size.height / simulation.height;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	for (int row = 0; row < simulation.height; row++) {
		for (int col = 0; col < simulation.width; col++) {
			UIColor *color = [simulation colorForCellAtX:col y:row];
			if (!color) continue;
			
			float size = [simulation sizeForCellAtX:col y:row];
			
			CGRect rect = CGRectMake((col + (1.0-size)/2.0) * dx, (row + (1.0-size)/2.0) * dy, size * dx, size * dy);
			CGContextSetFillColorWithColor(ctx, color.CGColor);
			CGContextFillRect(ctx, rect);
		}
	}
	
	for (ALifeCritter *critter in simulation.critters) {
		UIColor *color = [simulation colorForCritter:critter];
		if (!color) continue;
		
		float size = [simulation sizeForCritter:critter];
		
		CGRect rect = CGRectMake((critter.x + (1.0-size)/2.0) * dx, (critter.y + (1.0-size)/2.0) * dy, size * dx, size * dy);
		CGContextSetFillColorWithColor(ctx, color.CGColor);
		CGContextFillRect(ctx, rect);
	}
}

- (void)dealloc {
	[simulation removeObserver:self forKeyPath:@"foodImage"];
	[simulation release], simulation = nil;
	
    [super dealloc];
}

- (void)setSimulation:(ALifeSimulation *)newSimulation;
{
	if (simulation == newSimulation)
		return;
	
	[simulation removeObserver:self forKeyPath:@"foodImage"];
	[simulation release];
	simulation = [newSimulation retain];
	[simulation addObserver:self forKeyPath:@"foodImage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)theKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	[self setNeedsDisplay];
}

@end
