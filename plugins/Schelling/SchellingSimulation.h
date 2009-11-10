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
	
	int zero;
	int one;
	int two;
	int three;
	int four;
	int five;
	int six;
	int seven;
	int eight;
	
	int raceCount;
	float initialPopulationDensity;
}

@property(readwrite) int zero;
@property(readwrite) int one;
@property(readwrite) int two;
@property(readwrite) int three;
@property(readwrite) int four;
@property(readwrite) int five;
@property(readwrite) int six;
@property(readwrite) int seven;
@property(readwrite) int eight;

@property(nonatomic, assign) int generation;

@property (nonatomic, assign) int raceCount;
@property (nonatomic, assign) float initialPopulationDensity;

- (id)initWithWidth:(int)gameWidth height:(int)gameHeight;
- (void)seed;
- (void)update;
- (SchellingCell *)cellAtRow:(int)row column:(int)column;

- (NSMutableArray *)blankGrid;
- (void)setCellRelations;

- (BOOL)cellShouldMove:(SchellingCell *)cell;

//- (void)initGameOperations;
//- (OperationOfLife *)operationForCell:(CellOfLife *)cell type:(int)type;

@property(readwrite) int width;
@property(readwrite) int height;
@property(readonly) NSMutableArray *grid;

@end
