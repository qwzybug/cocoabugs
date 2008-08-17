//
//  CellOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 4/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CellOfLife.h"

@implementation CellOfLife

@synthesize alive, neighbors, row, column;

- (id)initWithRow:(int)r column:(int)c;
{
	if (!(self = [super init]))
		return nil;
	
	alive = NO;
	row = r;
	column = c;
	
	neighbors = [[NSMutableSet set] retain];
	
	return self;
}

- (void)dealloc;
{
	[neighbors release];
	
	[super dealloc];
}

- (int)liveNeighbors;
{
	int count = 0;
	for (CellOfLife *cell in [neighbors allObjects]) {
		if (cell.alive) count += 1;
	}
	return count;
}

@end
