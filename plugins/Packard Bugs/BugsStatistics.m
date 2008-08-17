//
//  BugsStatistics.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BugsStatistics.h"

#import "World.h"

@implementation BugsStatistics

@synthesize population, births, deaths, mortalityAge, averageAge;

- (id)initWithWorld:(World *)theWorld;
{
	if (!(self = [super init]))
		return nil;
	
	world = [theWorld retain];
	
	[world addObserver:self forKeyPath:@"ticks" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

- (void)dealloc;
{
	[world release];
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([keyPath isEqual:@"ticks"]) {
		[self updateStatistics];
	}
}

- (void)updateStatistics;
{
	// population
	self.population = [NSSet setWithObject:[NSNumber numberWithInt:[world.bugs count]]];
	
	// births
	self.births = [NSSet setWithObject:[NSNumber numberWithInt:[world.maternity count]]];
	
	// deaths
	self.deaths = [NSSet setWithObject:[NSNumber numberWithInt:[world.morgue count]]];
	
	// average age
	int ages = 0;
	for (Bug *bug in world.bugs) { ages += bug.age; }
	if ([world.bugs count] > 0)
		self.averageAge = [NSSet setWithObject:[NSNumber numberWithInt:(ages / [world.bugs count])]];
	else
		self.averageAge = [NSSet setWithObject:[NSNumber numberWithInt:0]];
	
	// age of mortality
	ages = 0;
	for (Bug *bug in world.morgue) { ages += bug.age; }
	if ([world.morgue count] > 0)
		self.mortalityAge = [NSSet setWithObject:[NSNumber numberWithInt:(ages / [world.morgue count])]];
	else
		self.mortalityAge = [NSSet setWithObject:[NSNumber numberWithInt:0]];	
}


@end
