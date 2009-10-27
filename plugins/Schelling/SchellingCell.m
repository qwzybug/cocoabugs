//
//  CellOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 4/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SchellingController.h"
#import "SchellingSimulation.h"
#import "SchellingCell.h"
#import "SchellingBoard.h"
#import "SchellingStatistics.h"

@implementation SchellingCell

@synthesize race, neighbors, row, column;

- (id)initWithRow:(int)r column:(int)c;
{
	if (!(self = [super init]))
		return nil;
	
	race = 0;
	row = r;
	column = c;
	
	neighbors = [[NSMutableSet set] retain];
	return self;
}

- (void)dealloc;
{
	[neighbors release], neighbors = nil;
	
	[super dealloc];
}

- (int)liveNeighbors;
{
	int count = 0;
	for (SchellingCell *cell in [neighbors allObjects]) {
		if (cell.race > 0) count += 1;
	}
	return count;
}

- (int)sameNeighbors;
{
	int count = 0;
	for (SchellingCell *cell in [neighbors allObjects]){
		if (cell.race == race) count += 1;
	}
	return count;
}

- (id)closeCells;
{
	for (SchellingCell *cell in [neighbors allObjects]) {
		if (cell.race == 0){
			return cell;
		}
	}
	return nil;
}

@end
