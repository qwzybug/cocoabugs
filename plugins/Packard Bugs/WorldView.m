//
//  WorldView.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WorldView.h"

#import "World.h"
#import "Cell.h"
#import "Bug.h"

@implementation WorldView

@synthesize world;
@synthesize colorGene;

- (void)dealloc;
{
	self.world = nil;
	
	[super dealloc];
}

float rotationForPoint(int x, int y) {
	// hooray magic numbers!
	if (x > 0) {
		if (y > 0) {
			return 0.125;
		} else if (y < 0) {
			return 0.875;
		} else {
			return 0.0;
		}
	} else if (x < 0) {
		if (y > 0) {
			return 0.375;
		} else if (y < 0) {
			return 0.625;
		} else {
			return 0.5;
		}
	} else {
		if (y > 0) {
			return 0.25;
		} else if (y < 0) {
			return 0.75;
		} else {
			return 0.0;
		}
	}
}

- (void)drawRect:(NSRect)rect {
	if (!world)
		return;
	
	// draw background
	[[NSColor colorWithDeviceWhite:0.3 alpha:1.0] set];
	NSRectFill([self bounds]);
	
	// rect arrays and counts
	NSRect food[world.foodAmount];
	NSRect bugs[world.population];
	int bugs_count = 0;
	int food_count = 0;
	
	float rectWidth = [self frame].size.width / [world.grid count];
	float rectHeight = [self frame].size.height / [[world.grid objectAtIndex:0] count];
	
	// color arrays
	NSColor *bugsColor[world.population];
	
	// loop it, dj
	int i = 0, j = 0;
	Bug *bug;
//	Bug *selectedBug = controller.selectedBug;
	BugMovement gene;
	NSMutableArray *row;
	Cell *cell;
	for (i = 0; i < [world.grid count]; i++) {
//	for (NSMutableArray *row in world.grid) {
		row = [world.grid objectAtIndex:i];
		for (j = 0; j < [row count]; j++) {
			cell = [row objectAtIndex:j];
			if(cell.food) {
				food[food_count] = NSMakeRect(rectWidth*j, rectHeight*i, rectWidth, rectHeight);
				food_count++;
			}
			if(bug = cell.bug) {
				gene = [bug getMovementForGene:colorGene];
				bugsColor[bugs_count] = [NSColor colorWithDeviceHue:rotationForPoint(gene.x, gene.y)
														 saturation:1.0
														 brightness:1.0
															  alpha:1.0];
//				if (bug == selectedBug) {
//					bugs[bugs_count] = NSMakeRect(5.0*j - 1.0, 5.0*i - 1.0, 7.0, 7.0);
//				} else {
					bugs[bugs_count] = NSMakeRect(rectWidth*j + 1.0, rectHeight*i + 1.0, rectWidth - 2.0, rectHeight - 2.0);
//				}
				bugs_count++;
			}
		}
	}
	[[NSColor blackColor] set];
	NSRectFillList(food, food_count);
	NSRectFillListWithColors(bugs, bugsColor, bugs_count);
}

//- (void)mouseDown:(NSEvent *)theEvent {
//	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//	int col = (int)(point.x / 5);
//	int row = (int)(point.y / 5);
//	[controller cellPokedAtRow:row andColumn:col];
//}

@end
