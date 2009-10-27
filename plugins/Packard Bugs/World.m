//
//  World.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "World.h"

@implementation World

// world properties & statistics
@synthesize width, height, population, births, deaths, lifespan, ticks, activeGeneCounts;
@synthesize grid, bugs, morgue, maternity;

// bug properties
@synthesize mutationRate, reproductionFood, movementCost, eatAmount;

// food configuration synthesized methods
@synthesize foodImage, foodAmount;

- (id)initWithFoodImage:(NSImage *)image;
{
	if (!(self = [super init]))
		return nil;
	
	int i, j;
	if (image) {
		width = [image size].width;
		height = [image size].height;
	} else {
		width = height = 100;
	}
	
	population = 0;
	ticks = 0;
	
	mutationRate = 0.5;
	reproductionFood = 20;
	movementCost = 1;
	eatAmount = 1;
	foodAmount = 0;
	
	grid = [[NSMutableArray arrayWithCapacity:height] retain];
	
	bugs = [[NSMutableSet set] retain];
	morgue = [[NSMutableSet set] retain];
	maternity = [[NSMutableSet set] retain];
	
	NSMutableArray *row;
	Cell *cell;
	for (i = 0; i < height; i++) {
		row = [NSMutableArray arrayWithCapacity:width];
		for (j = 0; j < width; j++) {
			cell = [[[Cell alloc] initWithFood:NO atRow:i column:j] autorelease];
			[row addObject:cell];
		}
		[grid addObject:row];
	}
	
	self.foodImage = image;
	
	return self;
}

- (void)setMovementCost:(int)newMovementCost;
{
	movementCost = newMovementCost;
}

- (void)setFoodImage:(NSImage *)image;
{
	if (foodImage == image)
		return;
	
	[foodImage release];
	foodImage = [image retain];
	
	NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
	BOOL sample;
	int i = 0, j = 0;
	float xScale = (float)[image size].width / width;
	float yScale = (float)[image size].height / height;
	foodAmount = 0;
	for (NSArray *row in grid) {
		j = 0;
		for (Cell *cell in row) {
			sample = [[bitmap colorAtX:(j * xScale) y:((height - i - 1) * yScale)] brightnessComponent] < 0.5;
			cell.food = sample;
			if (sample) foodAmount += 1;
			j++;
		}
		i++;
	}
}

- (void)dealloc;
{
	self.grid = nil;
	self.bugs = nil;
	self.morgue = nil;
	self.maternity = nil;
	[foodImage release], foodImage = nil;
	
	[super dealloc];
}

- (Cell *)cellAtRow:(int)row andColumn:(int)col;
{
	row = row < 0 ? height + row : row % height;
	col = col < 0 ? width + col : col % width;
	return [[grid objectAtIndex:row] objectAtIndex:col];
}

- (void)update;
{
	// blank statistics for accumulation
	population = 0;
	[morgue removeAllObjects];
	[maternity removeAllObjects];
	
	for (Bug *bug in [[self.bugs allObjects] shuffledArray]) {
		// check for bug death
		if (bug.food <= 0) {
			[self cellAtRow:bug.y andColumn:bug.x].bug = nil;
			[bugs removeObject:bug];
			[morgue addObject:bug];
			lifespan += bug.age;
			continue;
		}
		
		// check for reproduction
		if (bug.food > reproductionFood) {
			Bug *newBug = [bug doReproduceWithMutationRate:mutationRate];
			[self place:newBug atRow:bug.y andCol:bug.x];
			[bugs addObject:newBug];
			[maternity addObject:newBug];
			population++;
		}
		population++;
		
		// perform buggy movement and eating
		[self updateBug:bug atRow:bug.y column:bug.x];
	}
	self.population = population;
	self.ticks++;
}

- (int)calculateNeighborhoodForCellAtRow:(int)i andColumn:(int)j;
{
	int gene = 0;
	Cell *cell, *upCell, *leftCell, *rightCell, *downCell;
	
	// get neighborhood for each bug
	cell	  = [self cellAtRow:i	andColumn:j];
	upCell	  = [self cellAtRow:i+1 andColumn:j];
	leftCell  = [self cellAtRow:i	andColumn:j-1];
	rightCell = [self cellAtRow:i	andColumn:j+1];
	downCell  = [self cellAtRow:i-1 andColumn:j];
	
	// calculate relevant gene #
	if (upCell.food)
		gene = gene | 1;
	if (leftCell.food)
		gene = gene | 2;
	if (cell.food)
		gene = gene | 4;
	if (rightCell.food)
		gene = gene | 8;
	if (downCell.food)
		gene = gene | 16;
	
	return gene;
}

- (void)exterminate;
{
	for (NSMutableArray *row in grid) {
		for (Cell *cell in row) {
			cell.bug = nil;
		}
	}
	[bugs removeAllObjects];
	population = 0;
}

- (void)updateBug:(Bug *)bug atRow:(int)row column:(int)col;
{
	Cell *cell = [self cellAtRow:row andColumn:col];
	// check for food
	if (cell.food) {
		[bug doEat:eatAmount];
	} else {
		[bug doDigest:movementCost];
	}
	// bug has survived to bug another day
	bug.age++;
	
	// get neighborhood for cell
	int gene = [self calculateNeighborhoodForCellAtRow:row andColumn:col];
	// get movement for neighborhood
	BugMovement move = [bug getMovementForGene:gene];
	// place bug at new position
	[self place:bug atRow:(row + move.y) andCol:(col + move.x)];
	// remove old bug pointer
	cell.bug = nil;
}

- (void)place:(Bug *)bug atRow:(int)row andCol:(int)col;
{
	Cell *cell = [self cellAtRow:row andColumn:col];
	// check if cell is occupied
	if (cell.bug) {
		// if so, randomly adjust row and col, and replace
		[self place:bug atRow:(row + random() % 3 - 1) andCol:(col + random() % 3 - 1)];
	} else {
		cell.bug = bug;
		bug.x = cell.col;
		bug.y = cell.row;
	}
}

- (void)seedBugsWithDensity:(float)density;
{
	Bug *bug;
	int i, j, pop = 0;
	for (i = 0; i < height; i++) {
		for(j = 0; j < width; j++) {
			if ((float)random() / pow(2,31) < density) {
				bug = [[[Bug alloc] init] autorelease];
				[self place:bug atRow:i andCol:j];
				[bugs addObject:bug];
				pop++;
			}
		}
	}
	self.population = pop;
}

@end
