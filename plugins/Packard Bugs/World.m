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
@synthesize width, height, population, births, deaths, lifespan, ticks;
@synthesize grid, bugs, morgue, maternity;

// bug properties
@synthesize mutationRate, reproductionFood, movementCost, eatAmount;

// food configuration synthesized methods
@synthesize foodBlockWidth, foodBlockHeight, foodBlockNumber, foodAmount;

- (id)initWithFoodImage:(NSImage *)foodImage;
//- (id)initWithWidth:(int)myWidth andHeight:(int)myHeight;
{
	if (!(self = [super init]))
		return nil;
	
	int i, j;
	if (foodImage) {
		width = [foodImage size].width;
		height = [foodImage size].height;
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
	NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[foodImage TIFFRepresentation]];
	BOOL sample;
	for (i = 0; i < height; i++) {
		row = [NSMutableArray arrayWithCapacity:width];
		for (j = 0; j < width; j++) {
			sample = [[bitmap colorAtX:j y:(height - i - 1)] brightnessComponent] < 0.5;
			if (sample)
				foodAmount += 1;
			cell = [[[Cell alloc] initWithFood:sample atRow:i column:j] autorelease];
			[row addObject:cell];
		}
		[grid addObject:row];
	}
	
	return self;
}

- (void)dealloc;
{
	self.grid = nil;
	self.bugs = nil;
	self.morgue = nil;
	self.maternity = nil;
	
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
	int i = 0, j;
	Bug *bug, *newBug;
	
	// copy bug pointers into C array, so we don't move bugs more than once
	Bug *currentBugs[height][width];
	for (i = 0; i < height; i++) {
		for(j = 0; j < width; j++) {
			currentBugs[i][j] = ((Cell *)[[grid objectAtIndex:i] objectAtIndex:j]).bug;
		}
	}
	
	// blank statistics for accumulation
	population = 0;
	[morgue removeAllObjects];
	[maternity removeAllObjects];
	
	// loop through cells
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			// check for no bug
			if (!(bug = currentBugs[i][j]))
				continue;
			
			// check for bug death
			if (bug.food <= 0) {
				[self cellAtRow:i andColumn:j].bug = nil;
				[bugs removeObject:bug];
				[morgue addObject:bug];
				lifespan += bug.age;
				continue;
			}
			
			// check for reproduction
			if (bug.food > reproductionFood) {
				newBug = [bug doReproduceWithMutationRate:mutationRate];
				[self place:newBug atRow:i andCol:j+1];
				[bugs addObject:newBug];
				[maternity addObject:newBug];
				population++;
			}
			population++;
			// perform buggy movement and eating
			[self updateBug:bug atRow:i column:j];
		}
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

- (void)setFoodConfiguration:(bool *)newFood;
{
	int i, j;
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			[self cellAtRow:i andColumn:j].food = newFood[i*width + j];
		}
	}
}

- (void)regenerateFood;
{
	int row, col, i, j;
	int foodBlocks = 0;
	bool food[height][width];
	for (i = 0; i < height; i++){for(j=0;j<width;j++){food[i][j]=NO;}}
	while(foodBlocks < foodBlockNumber) {
		// pick a food block corner
		row = random() % (height - foodBlockHeight);
		col = random() % (width - foodBlockWidth);
		// seed food array depending on block widdth/height
		for (i = 0; i < foodBlockHeight; i++) {
			for (j = 0; j < foodBlockWidth; j++) {
				food[row+i][col+j] = YES;
			}
		}
		foodBlocks++;
	}
	[self setFoodConfiguration:food];
	foodAmount = foodBlockNumber * foodBlockHeight * foodBlockWidth;
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
