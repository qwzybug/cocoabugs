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

@property (nonatomic, strong) NSMutableSet *bugs;
@property (nonatomic, strong) NSMutableSet *morgue;
@property (nonatomic, strong) NSMutableSet *maternity;
@property (nonatomic, strong) NSCountedSet *activeGeneCounts;

@property (nonatomic, assign) int height;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int population;
@property (nonatomic, assign) int births;
@property (nonatomic, assign) int deaths;
@property (nonatomic, assign) int lifespan;
@property (nonatomic, assign) int ticks;
@property (nonatomic, assign) float mutationRate;
@property (nonatomic, assign) int reproductionFood;
@property (nonatomic, assign) int movementCost;
@property (nonatomic, assign) int eatAmount;
@property (nonatomic, copy) NSMutableArray *grid;
@property (nonatomic, strong) NSImage *foodImage;

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
