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
	NSImage *foodImage;
	int foodAmount;
	
	NSMutableArray *grid;
	
	// census groups
	NSMutableSet *bugs;			// all living bugs
	NSMutableSet *morgue;		// bugs that died each generation
	NSMutableSet *maternity;	// bugs born each generation
	NSCountedSet *activeGeneCounts; // counts of genes used each generation
	
	// activity statistics
	BOOL collectActivity;
	long *activity;
	int activitySize;
	int activityStep;
	int activityDelta;
}

@property (readwrite, retain) NSMutableSet *bugs;
@property (readwrite, retain) NSMutableSet *morgue;
@property (readwrite, retain) NSMutableSet *maternity;
@property (readwrite, retain) NSCountedSet *activeGeneCounts;

@property (readwrite) int height;
@property (readwrite) int width;
@property (readwrite) int population;
@property (readwrite) int births;
@property (readwrite) int deaths;
@property (readwrite) int lifespan;
@property (readwrite) int ticks;
@property (readwrite) float mutationRate;
@property (readwrite) int reproductionFood;
@property (readwrite) int movementCost;
@property (readwrite) int eatAmount;
@property (copy, readwrite) NSMutableArray *grid;
@property (nonatomic, retain) NSImage *foodImage;
@property (readonly) int foodAmount;

- (id)initWithFoodImage:(NSImage *)foodImage;
- (void)setFoodImage:(NSImage *)image;
- (void)update;
- (void)exterminate;
- (void)seedBugsWithDensity:(float)density;

// make these private?
- (Cell *)cellAtRow:(int)row andColumn:(int)col;
- (int)calculateNeighborhoodForCellAtRow:(int)i andColumn:(int)j;
- (void)place:(Bug *)bug atRow:(int)row andCol:(int)col;
- (void)updateBug:(Bug *)bug atRow:(int)i column:(int)j;

// activity statistics
- (void)updateActivity;
- (NSArray *)activityLines;
@property (nonatomic, assign) BOOL collectActivity;

@end
