//
//  Bug.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Bug.h"

#define INITIAL_FOOD 10

@implementation Bug
@synthesize food, age, x, y;

- (id) init;
{
	if (!(self = [super init]))
		return nil;
	
	food = INITIAL_FOOD;
	age = 0;
	
	// generate movement genes
	int i;
	for (i = 0; i < 32; i++) {
		genes[i] = [self randomGene];
	}
	return self;
}

- (Bug *)initWithFood:(int)myFood andGenes:(BugMovement[])myGenes mutationRate:(float)mutationRate;
{
	if (!(self = [super init]))
		return nil;
	
	food = myFood;
	age = 0;
	
	// copy genes, mutate if necessary
	int i;
	for (i = 0; i < 32; i++) {
		if ((float)random() / 2147483647.0 < mutationRate) {
			genes[i] = [self randomGene];
		} else {
			genes[i] = myGenes[i];
		}
	}
	return self;
}

- (void)dealloc;
{
	[super dealloc];
}

- (void)doEat:(int) amount;
{
	self.food += amount;
}

- (void)doDigest:(int) amount;
{
	self.food -= amount;
}

- (Bug *)doReproduceWithMutationRate:(float) mutationRate;
{
	food = food / 2;
	return [[[Bug alloc] initWithFood:food andGenes:genes mutationRate:mutationRate] autorelease];
}

- (BugMovement)getMovementForGene:(int) num;
{
	return genes[num];
}

- (int)hashForGene:(int)num;
{
	BugMovement gene = genes[num];
	return ((gene.x + 15) << 10) | ((gene.y + 15) << 5) | num;
}

- (BugMovement)randomGene;
{
	BugMovement move;
	int magnitude, diag;
	// magnitude: from 1 to 15
	magnitude = (random() % 15 + 1);
	// diagonal: 0 for on an axis, 1 for on a diagonal
	diag = (random() % 2);
	// quadrants
	switch(random() % 4) {
	case 0: // first quadrant
		move.x = magnitude;
		move.y = magnitude * diag;
		break;
	case 1: // second quadrant
		move.x = -magnitude * diag;
		move.y = magnitude;
		break;
	case 2: // third quadrant
		move.x = -magnitude;
		move.y = -magnitude * diag;
		break;
	case 3: // fourth quadrant
		move.x = magnitude * diag;
		move.y = -magnitude;
		break;
	}
	move.heritage = self.hash;
	return move;
}


@end