//
//  BugsStatistics.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BugsStatistics.h"

#import "World.h"
#import "UpdateGenePresenceOperation.h"

@implementation BugsStatistics

@synthesize population, births, deaths, mortalityAge, averageAge;
@synthesize totalGenePresence, accumulatedGenePresence;

- (id)initWithWorld:(World *)theWorld;
{
	if (!(self = [super init]))
		return nil;
	
	world = theWorld;
	
	[world addObserver:self forKeyPath:@"ticks" options:NSKeyValueObservingOptionNew context:NULL];
	
	accumulatedGenePresence = [NSCountedSet setWithCapacity:2000];
	
	queue = [[NSOperationQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1];
	
	return self;
}

- (void)dealloc;
{
	[world removeObserver:self forKeyPath:@"ticks"];
	
	accumulatedGenePresence = nil;
	
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
	// TODO this was a premature optimization
//	if (world.ticks % 10 != 0)
//		return;
	
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
	
	// gene presence
//	NSArray *allHashes = [world.bugs valueForKey:@"geneHashes"];
//	[self performSelectorInBackground:@selector(updateTotalGenePresenceWithHashArrays:) withObject:allHashes];
//	UpdateGenePresenceOperation *operation = [[UpdateGenePresenceOperation alloc] initWithBugs:world.bugs statistics:self accumulatedGenePresence:accumulatedGenePresence];
//	[queue addOperation:[operation autorelease]];
//	for (Bug *bug in world.bugs) {
//		for (int i = 0; i < 32; i++) {
//			[accumulatedGenePresence addObject:[NSNumber numberWithInt:[bug hashForGene:i]]];
//		}
//	}
//	NSMutableSet *allCounts = [NSMutableSet setWithCapacity:[accumulatedGenePresence count]];
//	for (id gene in accumulatedGenePresence) {
//		[allCounts addObject:[NSNumber numberWithInt:[accumulatedGenePresence countForObject:gene]]];
//	}
//	self.totalGenePresence = accumulatedGenePresence;
}

- (void)updateTotalGenePresenceWithHashArrays:(NSArray *)allHashes;
{
	@autoreleasepool {
	
	// count gene presence
		for (NSArray *geneHashes in allHashes) {
			for (NSNumber *hash in geneHashes) {
				[accumulatedGenePresence addObject:hash];
			}
		}
		NSMutableSet *allCounts = [NSMutableSet setWithCapacity:[accumulatedGenePresence count]];
		for (id gene in accumulatedGenePresence) {
			[allCounts addObject:[NSNumber numberWithInt:[accumulatedGenePresence countForObject:gene]]];
		}
		
		[self performSelectorOnMainThread:@selector(setTotalGenePresence:) withObject:allCounts waitUntilDone:YES];
		self.totalGenePresence = allCounts;
	
	}
}

@end
