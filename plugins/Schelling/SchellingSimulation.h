//
//  SchellingSimulation.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SchellingCell, OperationOfLife;

@interface SchellingSimulation : NSObject {
	NSMutableArray *grid;
	
	int width;
	int height;
	int generation;
	int liveCells;
	
}

- (id)initWithWidth:(int)gameWidth height:(int)gameHeight;
//- (id)initWithWidth:(int)gameWidth height:(int)gameHeight configuration:(NSDictionary *)configuration;
- (void)update;
- (SchellingCell *)cellAtRow:(int)row column:(int)column;
//- (void)nearestUnoccupiedCellToRow:(int)row column:(int)col torace:(int)torace;

- (NSMutableArray *)blankGrid;
- (void)setCellRelations;

//- (void)initGameOperations;
//- (OperationOfLife *)operationForCell:(CellOfLife *)cell type:(int)type;

@property(readwrite) int width;
@property(readwrite) int height;
@property(readwrite) int generation;
@property(readonly) NSMutableArray *grid;

@end
