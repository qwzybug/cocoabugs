//
//  GameOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameOfLife.h"
#import "CellOfLife.h"
#import "OperationOfLife.h"
#import "QueueOfLife.h"

@implementation GameOfLife

@synthesize width, height, generation, grid;

- (id)initWithWidth:(int)gameWidth height:(int)gameHeight;
{
	if (!(self = [super init]))
		return nil;
	
	width = gameWidth;
	height = gameHeight;
	generation = 0;
	
	readers = 0;
	threads = 0;
	
	grid = [[self blankGrid] retain];
	[self setCellRelations];
	
	// init to r-pentomino
//	[self cellAtRow:(height / 2 + 1) column:(width / 2 - 1)].alive = 1;
//	[self cellAtRow:(height / 2 + 1) column:(width / 2)].alive = 1;
//	[self cellAtRow:(height / 2) column:(width / 2)].alive = 1;
//	[self cellAtRow:(height / 2) column:(width / 2 + 1)].alive = 1;
//	[self cellAtRow:(height / 2 - 1) column:(width / 2)].alive = 1;
	
	// set up operations
	workQueue = [[NSMutableArray alloc] init];
	nextQueue = [[NSMutableArray alloc] init];
	
	// set up thread conditions
	workCondition = [[NSCondition alloc] init];
	queueLock = [[NSLock alloc] init];
	nextLock = [[NSLock alloc] init];
	
//	[self initGameOperations];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Releasing game...");
	
	[workQueue release];
	[nextQueue release];
	[workCondition release];
	[queueLock release];
	[nextLock release];
	[grid release];
	
	[super dealloc];
}

- (void)update;
{
	// spawn some worker threads
	for (int i = 0; i < 2; i++) {
		threads++;
		[NSThread detachNewThreadSelector:@selector(threadMain) toTarget:self withObject:nil];
	}
	
	// wait for threads to finish their bidness
	[workCondition lock];
	while (threads > 0) {
		[workCondition wait];
	}
	[workCondition unlock];
	
	// prepare work for next step
	[self swapQueues];
	
	self.generation++;
}

- (void)workThread;
{
	[queueLock lock];
	OperationOfLife *op = [[workQueue dequeue] retain];
	if (!op) {
		[queueLock unlock];
		return;
	}

	[workCondition lock];
	[queueLock unlock];
	
	if (op.type == OP_READ) {
		readers++;
	} else {
		// writers should wait for all reads to finish
		while (readers > 0)
			[workCondition wait];
	}
	[workCondition unlock];
	
	[op go];
	
	[workCondition lock];
	if (op.type == OP_READ) {
		readers--;
	}
	[workCondition signal];
	[workCondition unlock];
	
	[op release];
}

// main loop for worker threads
- (void)threadMain;
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	while ([workQueue count] > 0) {
		[self workThread];
	}
	[pool release];
	
	[workCondition lock];
	threads--;
	[workCondition signal];
	[workCondition unlock];
}

- (CellOfLife *)cellAtRow:(int)row column:(int)column;
{
	row = row < 0 ? height + row : row % height;
	column = column < 0 ? width + column : column % width;
	return [[grid objectAtIndex:row] objectAtIndex:column];
}

// used to initialize worker threads when the game is created
- (void)initGameOperations;
{
	for (NSMutableArray *row in grid) {
		for (CellOfLife *cell in row) {
			if (cell.alive) {
				// should read alive cells to begin
				[self makeWork:OP_READ forCell:cell];
				// and also read their neighbors
				for (CellOfLife *neighbor in cell.neighbors) {
					[self makeWork:OP_READ forCell:neighbor];
				}
			}
		}
	}
}

// add work to queues
- (void)makeWork:(int)type forCell:(CellOfLife *)cell;
{
	if (type == OP_READ) {
		[nextLock lock];
		// reads are often duped
		[nextQueue enqueueUnique:[self operationForCell:cell type:OP_READ]];
		for (CellOfLife *neighbor in cell.neighbors) {
			[nextQueue enqueueUnique:[self operationForCell:neighbor type:OP_READ]];
		}
		[nextLock unlock];
	} else {
		[queueLock lock];
		// queued writing should already by unique: only one per read
		[workQueue enqueue:[self operationForCell:cell type:type]];
		[queueLock unlock];
	}
}

- (OperationOfLife *)operationForCell:(CellOfLife *)cell type:(int)type;
{
	return [[[OperationOfLife alloc] initWithGame:self cell:cell type:type] autorelease];
}

// swap the current and next work queues between generations
- (void)swapQueues;
{
	NSMutableArray *temp = workQueue;
	workQueue = nextQueue;
	nextQueue = temp;
}

// make a blank cell grid
- (NSMutableArray *)blankGrid;
{
	NSMutableArray *blank = [NSMutableArray arrayWithCapacity:(width * height)];
	NSMutableArray *row;
	CellOfLife *cell;
	for (int i = 0; i < height; i++) {
		row = [NSMutableArray arrayWithCapacity:width];
		for (int j = 0; j < width; j++) {
			cell = [[[CellOfLife alloc] initWithRow:i column:j] autorelease];
			[row addObject:cell];
		}
		[blank addObject:row];
	}
	return blank;
}

// let cells know who their neighbors are
- (void)setCellRelations;
{
	NSMutableArray *row;
	CellOfLife *cell;
	for (int i = 0; i < height; i++) {
		row = [grid objectAtIndex:i];
		for (int j = 0; j < width; j++) {
			cell = [row objectAtIndex:j];
			[cell.neighbors addObject:[self cellAtRow:(i - 1) column:(j - 1)]];
			[cell.neighbors addObject:[self cellAtRow:(i - 1) column:j]];
			[cell.neighbors addObject:[self cellAtRow:(i - 1) column:(j + 1)]];
			[cell.neighbors addObject:[self cellAtRow:i column:(j - 1)]];
			[cell.neighbors addObject:[self cellAtRow:i column:(j + 1)]];
			[cell.neighbors addObject:[self cellAtRow:(i + 1) column:(j - 1)]];
			[cell.neighbors addObject:[self cellAtRow:(i + 1) column:j]];
			[cell.neighbors addObject:[self cellAtRow:(i + 1) column:(j + 1)]];
		}
	}
}

@end
