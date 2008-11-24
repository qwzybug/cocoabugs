//
//  SchellingStatistics.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SchellingStatistics.h"

#import "SchellingSimulation.h"
#import "SchellingCell.h"

@implementation SchellingStatistics

@synthesize population, game;

- (id)initWithGame:(id)theGame;
{
	if (!(self = [super init]))
		return nil;
	
	self.game = theGame;
	
	[game addObserver:self forKeyPath:@"generation" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Releasing Statistics");
	NSLog(@"%d", [game retainCount]);
	
	[game removeObserver:self forKeyPath:@"generation"];
	self.game = nil;
	self.population = nil;
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([keyPath isEqual:@"generation"]) {
		[self updateStatistics];
	}
}

- (void)updateStatistics;
{
//	NSLog(@"Collating statistics...");
	
	// population
	int pop = 0;
	for(NSMutableArray *row in game.grid) {
		for (SchellingCell *cell in row) {
			int samies = [cell sameNeighbors];
				pop = pop + samies;
		}
	}
	self.population = [NSSet setWithObject:[NSNumber numberWithInt:pop]];
}

@end
