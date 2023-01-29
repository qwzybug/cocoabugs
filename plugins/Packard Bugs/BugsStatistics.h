//
//  BugsStatistics.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class World;

@interface BugsStatistics : NSObject {
	World *world;
	
	NSSet *population;
	NSSet *deaths;
	NSSet *births;
	NSSet *mortalityAge;
	NSSet *averageAge;
	
	NSSet *totalGenePresence;
	NSSet *totalGeneActivity;
	
	NSCountedSet *accumulatedGenePresence;
	NSCountedSet *accumulatedGeneActivity;
	
	NSOperationQueue *queue;
}

- (id)initWithWorld:(World *)theWorld;
- (void)updateStatistics;

@property(readwrite, strong) NSSet *population;
@property(readwrite, strong) NSSet *deaths;
@property(readwrite, strong) NSSet *births;
@property(readwrite, strong) NSSet *mortalityAge;
@property(readwrite, strong) NSSet *averageAge;

@property(nonatomic, strong) NSSet *totalGenePresence;
@property(nonatomic, strong) NSCountedSet *accumulatedGenePresence;

- (void)updateTotalGenePresenceWithHashArrays:(NSArray *)geneHashes;

@end
