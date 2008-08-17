//
//  OperationOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OperationOfLife.h"
#import "GameOfLife.h"
#import "CellOfLife.h"

@implementation OperationOfLife

@synthesize game, type, cell;

- (id)initWithGame:(GameOfLife *)lifeGame cell:(CellOfLife *)lifeCell type:(int)opType;
{
	if (!(self = [super init])) return nil;
	
	game = lifeGame;
	cell = lifeCell;
	type = opType;
	
	return self;
}

- (BOOL)isEqual:(OperationOfLife *)op;
{
	return (op.cell == cell && op.game == game && op.type == type);
}

- (void)dealloc;
{
//	NSLog(@"Releasing operation...");
//	[game release];
//	[cell release];
	
	[super dealloc];
}

- (void)go;
{
	if (type == OP_READ) {
		// read the cell; add a new WRITE process if its value has changed
		int neighbors = [cell liveNeighbors];
		if (cell.alive) {
			if (neighbors < 2 || neighbors > 3) {
				// add work queue item to kill
				[game makeWork:OP_DEAD forCell:cell];
			}
		} else {
			// if dead, resurrect if necessary
			if (neighbors == 3) {
				// add work queue item to write a 1
				[game makeWork:OP_LIVE forCell:cell];
			}
		}
	} else {
		if (type == OP_LIVE) {
			cell.alive = YES;
		} else {
			cell.alive = NO;
		}
		// add new reads
		[game makeWork:OP_READ forCell:cell];
	}
}

@end
