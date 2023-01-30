//
//  UpdateGenePresenceOperation.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UpdateGenePresenceOperation.h"

#import "Bug.h"
#import "BugsStatistics.h"

@implementation UpdateGenePresenceOperation

- (id)initWithBugs:(NSSet *)bugs statistics:(BugsStatistics *)inStatistics accumulatedGenePresence:(NSCountedSet *)inAccumulatedGenePresence;
{
	if (!(self = [super init]))
		return nil;
	
	allBugs = [bugs copy];
	statistics = inStatistics;
	accumulatedGenePresence = inAccumulatedGenePresence;
	
	return self;
}

- (void)dealloc;
{
	allBugs = nil;
	statistics = nil;
	accumulatedGenePresence = nil;
	
}

- (void)main;
{
	// count gene presence
	for (Bug *bug in allBugs) {
		for (int i = 0; i < 32; i++) {
			[accumulatedGenePresence addObject:[NSNumber numberWithInt:[bug hashForGene:i]]];
		}
	}
	NSMutableSet *allCounts = [NSMutableSet setWithCapacity:[accumulatedGenePresence count]];
	for (id gene in accumulatedGenePresence) {
		[allCounts addObject:[NSNumber numberWithInteger:[accumulatedGenePresence countForObject:gene]]];
	}
	
	statistics.accumulatedGenePresence = accumulatedGenePresence;
	statistics.totalGenePresence = allCounts;
	
}

@end
