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

@synthesize game;
@synthesize segregation, diversity;

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
	self.segregation = nil;
	self.diversity = nil;
	
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
	// segregation and diversity
	int diff = 0;
	int same = 0;
	int pop = 0;
	for(NSMutableArray *row in game.grid) {
		for (SchellingCell *cell in row) {
			int neighbors = [cell liveNeighbors];
			int sameNeighbors = [cell sameNeighbors];
			pop++;
			same = same + sameNeighbors;
			diff = diff + (neighbors - sameNeighbors);
		}
	}
	float segregationRate = (float)same / pop;
	float diversityRate = (float)diff / pop;
	
	self.segregation = [NSSet setWithObject:[NSNumber numberWithFloat:segregationRate]];
	self.diversity = [NSSet setWithObject:[NSNumber numberWithFloat:diversityRate]];
}

@end
