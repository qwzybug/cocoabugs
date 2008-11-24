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


- (id)initWithWidth:(int)gameWidth height:(int)gameHeight; //configuration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	width = gameWidth;
	height = gameHeight;
	generation = 0;
	
	
	grid = [[self blankGrid] retain];
	[self setCellRelations];
	
	// init to r-pentomino
//	[self cellAtRow:(height / 2 + 1) column:(width / 2 - 1)].alive = 1;
//	[self cellAtRow:(height / 2 + 1) column:(width / 2)].alive = 1;
//	[self cellAtRow:(height / 2) column:(width / 2)].alive = 1;
//	[self cellAtRow:(height / 2) column:(width / 2 + 1)].alive = 1;
//	[self cellAtRow:(height / 2 - 1) column:(width / 2)].alive = 1;
	
	// set up operation	
	//int raceCount = 2;
	//raceCount = [[configuration objectForKey:@"races"]intValue];
//	[self initGameOperations];
	for (NSMutableArray *row in grid) {
		for (SchellingCell *cell in row) {
			cell.race = cell.race;//(random() % raceCount);
		}
		
}
	return self;
}



- (SchellingCell *)cellAtRow:(int)row column:(int)column;
{
	row = row < 0 ? height + row : row % height;
	column = column < 0 ? width + column : column % width;
	return [[grid objectAtIndex:row] objectAtIndex:column];
}

//- (OperationOfLife *)operationForCell:(CellOfLife *)cell type:(int)type;
//{
//	return [[[OperationOfLife alloc] initWithGame:self cell:cell type:type] autorelease];
//}

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


//- (void)nearestUnoccupiedCellToRow:(int)row column:(int)col torace:(int)torace;
//{
//	int i, j;
//	CellOfLife *closestCell, *cell;
//	int closestDistance = 9999;
//	for (i = 0; i < height; i++) {
//		for (j = 0; j < width; j++) {
//			cell = [self cellAtRow:i column:j];
//			if (cell.race == 0) {
//				if (abs(row-i) + abs(col-j) < closestDistance) {
//					closestCell = cell;
//					closestDistance = abs(row-i) + abs(col-j);
//				}
//			}
//		}
//	}
//	closestCell.race = torace;
//}

//-(void)update;
//{
//	//Get a list of live cells
//	NSMutableArray *livers = [NSMutableArray arrayWithCapacity:([grid count]*[grid count])];
//	for (NSMutableArray *row in grid) {
//		for (CellOfLife *cell in row){
//			//CellOfLife *cell = [row objectAtIndex:(random() % [row count])];
//			if (cell.race != 0){
//			//cell.race = (cell.race+1) % 3;
//				[livers addObject:cell];
//			}
//		}
//	}
//
//	//Shuffle the list
//	srandom([[NSDate date] timeIntervalSince1970]);
//	int count = [livers count];
//	for (int i = 0; i < count; ++i) {
//		// Select a random element between i and end of array to swap with.
//		int nElements = count - i;
//		int n = (random() % nElements) + i;
//		//int n = (random() % count);
//		[livers exchangeObjectAtIndex:i withObjectAtIndex:n];
//	}
//	
//	for (CellOfLife *cell in livers){
//		BOOL moving = [cell moved];
//	if (moving){
//		//if (samies/neighbors < 0.75) {
//		//((neighbors > 1) && (neighbors < 6) && (samies < 3))
//		NSMutableArray *closestCells = [NSMutableArray arrayWithCapacity:5];
//		int i, j;
//		CellOfLife *closestCell, *bell;
//		int closestDistance = 9999;
//		for (i = 0; i < height; i++) {
//			for (j = 0; j < width; j++) {
//				bell = [self cellAtRow:i column:j];
//				if (bell.race == 0) {
//					if (abs(cell.row-i) + abs(cell.column-j) < closestDistance) {
//						[closestCells removeAllObjects];
//						closestCell = bell;
//						closestDistance = abs(cell.row-i) + abs(cell.column-j);
//						[closestCells addObject:bell];
//					} else if (abs(cell.row-i) + abs(cell.column-j) <= closestDistance+2) {
//						[closestCells addObject:bell];
//					}
//				}
//			}
//		}
//		CellOfLife *tome = [closestCells objectAtIndex:(random() % [closestCells count])];
//		tome.race = cell.race;
//		cell.race = 0;
//		}
//	}
//}







- (void)update;
{
	srandom([[NSDate date] timeIntervalSince1970]);
	int count = [grid count];
	for (int i = 0; i < count; ++i) {
		// Select a random element between i and end of array to swap with.
		//int nElements = count - i;
		//int n = (random() % nElements) + i;
		int n = (random() % count);
		[grid exchangeObjectAtIndex:i withObjectAtIndex:n];
	}
	
	for (NSMutableArray *row in grid) {
		
		count = [row count];
		for (int i = 0; i < count; ++i) {
			// Select a random element between i and end of array to swap with.
			//int nElements = count - i;
			//int n = (random() % nElements) + i;
			int n = (random() % count);
			[row exchangeObjectAtIndex:i withObjectAtIndex:n];
		}
		
		//NSMutableArray *row = [grid objectAtIndex:(random() % [grid count])];
		for (SchellingCell *cell in row) {
			//NSMutableArray *row = [grid objectAtIndex:(random() % [grid count])];
			SchellingCell *cell = [row objectAtIndex:(random() % [row count])];
			//int neighbors = [cell liveNeighbors];
			//float samies = [cell sameNeighbors];
			if (cell.race > 0){
				//if ((neighbors < 3) && (samies < 1)) || ((neighbors > 1) && (neighbors < 6) && (samies < 3)) || {
				BOOL moving = [cell moved];
				if (moving){
				//if (samies/neighbors < 0.75) {
				//((neighbors > 1) && (neighbors < 6) && (samies < 3))
					NSMutableArray *closestCells = [NSMutableArray arrayWithCapacity:10];
					int i, j;
					SchellingCell *closestCell, *bell;
					int closestDistance = 9999;
					for (i = 0; i < height; i++) {
						for (j = 0; j < width; j++) {
							bell = [self cellAtRow:i column:j];
							if (bell.race == 0) {
								if (abs(cell.row-i) + abs(cell.column-j) < closestDistance) {
									[closestCells removeAllObjects];
									closestCell = bell;
									closestDistance = abs(cell.row-i) + abs(cell.column-j);
									[closestCells addObject:bell];
								} else if (abs(cell.row-i) + abs(cell.column-j) <= closestDistance+2) {
									[closestCells addObject:bell];
								}}}}
								SchellingCell *tome = [closestCells objectAtIndex:(random() % [closestCells count])];
					tome.race = cell.race;
					cell.race = 0;
			}
		}
	}
	}}
// used to initialize worker threads when the game is created
//- (void)initGameOperations;
//{
//	for (NSMutableArray *row in grid) {
//		for (CellOfLife *cell in row) {
//			cell.race = (random() % 3);
//		}
//
//}
//}
@end
