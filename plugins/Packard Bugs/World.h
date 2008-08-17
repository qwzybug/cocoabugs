//
//  World.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Bug.h"
#import "Cell.h"

@class WorldStatistics;

@interface World : NSObject {
	int height;
	int width;
	
	// statistics - factor out into stats collector
	int population;
	int births;
	int deaths;
	int lifespan;
	
	int ticks;
	
	// configuration parameters
	float mutationRate;
	int reproductionFood;
	int movementCost;
	int eatAmount;
	// environment
	int foodBlockWidth;
	int foodBlockHeight;
	int foodBlockNumber;
	int foodAmount;
	
	NSMutableArray *grid;
	
	// census groups
	NSMutableSet *bugs;			// all living bugs
	NSMutableSet *morgue;		// bugs that died each generation
	NSMutableSet *maternity;	// bugs born each generation
}

@property(readwrite, copy) NSMutableSet *bugs;
@property(readwrite, copy) NSMutableSet *morgue;
@property(readwrite, copy) NSMutableSet *maternity;

@property(readwrite) int height;
@property(readwrite) int width;
@property(readwrite) int population;
@property(readwrite) int births;
@property(readwrite) int deaths;
@property(readwrite) int lifespan;
@property(readwrite) int ticks;
@property(readwrite) float mutationRate;
@property(readwrite) int reproductionFood;
@property(readwrite) int movementCost;
@property(readwrite) int eatAmount;
@property(copy, readwrite) NSMutableArray *grid;
@property(assign, readwrite) int foodBlockWidth;
@property(assign, readwrite) int foodBlockHeight;
@property(assign, readwrite) int foodBlockNumber;
@property(readonly) int foodAmount;

- (id)initWithWidth:(int)myWidth andHeight:(int)myHeight;
- (void)setFoodConfiguration:(bool *)newFood;
- (void)update;
- (void)exterminate;
- (void)regenerateFood;
- (void)seedBugsWithDensity:(float)density;

// make these private?
- (Cell *)cellAtRow:(int)row andColumn:(int)col;
- (int)calculateNeighborhoodForCellAtRow:(int)i andColumn:(int)j;
- (void)place:(Bug *)bug atRow:(int)row andCol:(int)col;
- (void)updateBug:(Bug *)bug atRow:(int)i column:(int)j;

@end
