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

@synthesize race, neighbors, row, column, zero, one, two, three, four, five, six, seven, eight;






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
	[neighbors release];
	
	[super dealloc];
}

- (int)liveNeighbors;
{
	int count = 0;
	for (SchellingCell *cell in [neighbors allObjects]) {
		if (cell.race>0) count += 1;
	}
	return count;
}
- (int)sameNeighbors;
{
	int count = 0;
	for (SchellingCell *cell in [neighbors allObjects]){
		if (cell.race==race) count += 1;
	}
	return count;
}
- (id)closeCells;
{
	for (SchellingCell *cell in [neighbors allObjects]) {
		if (cell.race==0){
			return cell;
		}
	}
}

//- (BOOL)moved;
//{
//	
//	int d = [self liveNeighbors];
//	int c = [self sameNeighbors];
//	if (d==0){
//		//if (self.zero == 1){
////			return TRUE;
////		}else{
////			return FALSE;
////		}
//		return TRUE;
//	}else if (( d == 1 ) || ( d == 2 )){
//		if (c < 1){
//			return TRUE;
//		}else{
//			return TRUE;
//		}
//	}else if (( d == 3 ) || ( d == 4 ) || (d == 5)){
//		if (c < 2){
//			return TRUE;
//		}else{
//			return FALSE;
//		}
//	}else if (d > 5){
//		if (c < 3){
//			return TRUE;
//		}else{
//			return FALSE;
//		}
//	}
//}

- (BOOL)moved;
{
	
	int d = [self liveNeighbors];
	int c = [self sameNeighbors];
	if (d== 0){
		//no neighbors
		if (zero == 1){
			return TRUE;
		}else{
			return FALSE;
		}
	}else if (d == 1){
		if (c < one){
			return TRUE;
		}else{
			return FALSE;
		}
	}else if (d == 2){
		if (c < two){
			return TRUE;
		}else{
			return FALSE;
		}
		
	}else if (d == 3){
		if (c < three){
			return TRUE;
		}else{
			return FALSE;
		}
		
	}else if (d == 4){
			if (c < four){
				return TRUE;
			}else{
				return FALSE;
			}
		
		
	}else if (d == 5){
		if (c < five){
			return TRUE;
		}else{
			return FALSE;
		}
	

	}else if (d == 6){
		if (c < six){
			return TRUE;
		}else{
			return FALSE;
		}

	}else if (d == 7){
		if (c < seven){
			return TRUE;
		}else{
			return FALSE;
		}

	}else if (d == 8){
		if (c < eight){
			return TRUE;
		}else{
			return FALSE;
		}
	}	
}

@end
