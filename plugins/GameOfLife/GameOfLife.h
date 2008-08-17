//
//  GameOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CellOfLife, OperationOfLife;

@interface GameOfLife : NSObject {
	NSMutableArray *grid;
	
	int width;
	int height;
	int generation;
	int liveCells;
	
	// work queues
	NSMutableArray *workQueue;
	NSMutableArray *nextQueue;
	
	// queue conditions
	NSLock *queueLock;
	NSLock *nextLock;
	BOOL queueWriting;
	BOOL nextWriting;
	
	// condition and associated counters
	NSCondition *workCondition;
	int readers;
	int threads;
}

- (id)initWithWidth:(int)gameWidth height:(int)gameHeight;
- (void)update;

- (CellOfLife *)cellAtRow:(int)row column:(int)column;

- (NSMutableArray *)blankGrid;
- (void)setCellRelations;

- (void)initGameOperations;
- (void)makeWork:(int)type forCell:(CellOfLife *)cell;
- (OperationOfLife *)operationForCell:(CellOfLife *)cell type:(int)type;
- (void)swapQueues;

@property(readwrite) int width;
@property(readwrite) int height;
@property(readwrite) int generation;
@property(readonly) NSMutableArray *grid;

@end
