//
//  SchellingSimulation.hm
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SchellingSimulation.h"
#import "SchellingCell.h"

@implementation SchellingSimulation;

@synthesize width, height, generation, grid;
@synthesize zero, one, two, three, four, five, six, seven, eight;
@synthesize raceCount;
@synthesize initialPopulationDensity;

- (id)initWithWidth:(int)gameWidth height:(int)gameHeight;
{
	if (!(self = [super init]))
		return nil;
	
	width = gameWidth;
	height = gameHeight;
	self.generation = 0;
	
	grid = [[self blankGrid] retain];
	[self setCellRelations];
	
	return self;
}

- (SchellingCell *)cellAtRow:(int)row column:(int)column;
{
	row = row < 0 ? height + row : row % height;
	column = column < 0 ? width + column : column % width;
	return [[grid objectAtIndex:row] objectAtIndex:column];
}

- (void)seed;
{
	for (NSArray *row in grid) {
		for (SchellingCell *cell in row) {
			if (initialPopulationDensity > (float)random() / INT_MAX) {
				cell.race = (1 + (random() % raceCount));
			} else {
				cell.race = 0;
			}
		}
	}
	self.generation = 0;
}

// make a blank cell grid
- (NSMutableArray *)blankGrid;
{
	NSMutableArray *blank = [NSMutableArray arrayWithCapacity:(width * height)];
	NSMutableArray *row;
	SchellingCell *cell;
	for (int i = 0; i < height; i++) {
		row = [NSMutableArray arrayWithCapacity:width];
		for (int j = 0; j < width; j++) {
			cell = [[[SchellingCell alloc] initWithRow:i column:j] autorelease];
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
	SchellingCell *cell;
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

- (void)update;
{
	srandom([[NSDate date] timeIntervalSince1970]);
	
	NSArray *shuffledGrid = [self.grid shuffledArray];
	NSArray *shuffledRow = nil;
	
	for (NSMutableArray *row in shuffledGrid) {
		shuffledRow = [row shuffledArray];
		for (SchellingCell *cell in shuffledRow) {
			if (cell.race > 0){
				if ([self cellShouldMove:cell]) {
					NSMutableArray *closestCells = [NSMutableArray arrayWithCapacity:10];
					int i, j;
					SchellingCell *bell;
					int closestDistance = 9999;
					for (i = 0; i < height; i++) {
						for (j = 0; j < width; j++) {
							bell = [self cellAtRow:i column:j];
							if (bell.race == 0) {
								if (abs(cell.row-i) + abs(cell.column-j) < closestDistance) {
									[closestCells removeAllObjects];
									closestDistance = abs(cell.row-i) + abs(cell.column-j);
									[closestCells addObject:bell];
								} else if (abs(cell.row-i) + abs(cell.column-j) <= closestDistance+2) {
									[closestCells addObject:bell];
								}
							}
						}
					}
					SchellingCell *tome = [closestCells objectAtIndex:(random() % [closestCells count])];
					tome.race = cell.race;
					cell.race = 0;
				}
			}
		}
	}
	self.generation++;
}

- (BOOL)cellShouldMove:(SchellingCell *)cell;
{
	
	int d = [cell liveNeighbors];
	int c = [cell sameNeighbors];
	if (d== 0){
		//no neighbors
		if (zero == 1){
			return YES;
		}else{
			return NO;
		}
	}else if (d == 1){
		if (c < one){
			return YES;
		}else{
			return NO;
		}
	}else if (d == 2){
		if (c < two){
			return YES;
		}else{
			return NO;
		}
		
	}else if (d == 3){
		if (c < three){
			return YES;
		}else{
			return NO;
		}
		
	}else if (d == 4){
		if (c < four){
			return YES;
		}else{
			return NO;
		}
		
		
	}else if (d == 5){
		if (c < five){
			return YES;
		}else{
			return NO;
		}
		
		
	}else if (d == 6){
		if (c < six){
			return YES;
		}else{
			return NO;
		}
		
	}else if (d == 7){
		if (c < seven){
			return YES;
		}else{
			return NO;
		}
		
	}else if (d == 8){
		if (c < eight){
			return YES;
		}else{
			return NO;
		}
	}
	return NO;
}

@end
