//
//  World.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bug.h"
#import "Cell.h"

#import "ALifeSimulation.h"
#import "PixelImage.h"

@interface World : ALifeSimulation {
	// statistics - factor out into stats collector
	int population;
	int births;
	int deaths;
	int lifespan;
	
	int ticks;
	
	// configuration parameters
	float mutationRate;
	int reproductionFood;
	float initialPopulationDensity;
	int movementCost;
	int eatAmount;
	// environment
#ifdef TARGET_OS_IPHONE
	UIImage *foodImage;
#else
	NSImage *foodImage;
#endif
//	NSImage *foodImage;
	int foodAmount;
	
	NSMutableArray *grid;
	
	// census groups
	NSMutableSet *morgue;		// bugs that died each generation
	NSMutableSet *maternity;	// bugs born each generation
	NSCountedSet *activeGeneCounts; // counts of genes used each generation
	
	NSDictionary *currentActivity;
	
	// activity statistics
	BOOL collectActivity;
	long *activity;
	int activitySize;
	int activityStep;
	int activityDelta;
}

@property (readwrite, retain) NSMutableSet *morgue;
@property (readwrite, retain) NSMutableSet *maternity;
@property (readwrite, retain) NSCountedSet *activeGeneCounts;

@property (readwrite, copy) NSDictionary *currentActivity;

@property (readwrite) int population;
@property (readwrite) int births;
@property (readwrite) int deaths;
@property (readwrite) int lifespan;
@property (readwrite) int ticks;
@property (readwrite) float mutationRate;
@property (readwrite) float initialPopulationDensity;
@property (readwrite) int reproductionFood;
@property (readwrite) int movementCost;
@property (readwrite) int eatAmount;
@property (copy, readwrite) NSMutableArray *grid;
#ifdef TARGET_OS_IPHONE
@property (nonatomic, retain) UIImage *foodImage;
#else
@property (nonatomic, retain) NSImage *foodImage;
#endif
@property (readonly) int foodAmount;

//- (id)initWithFoodImage:(NSImage *)foodImage;
//- (void)setFoodImage:(NSImage *)image;
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
