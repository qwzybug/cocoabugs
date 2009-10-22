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

@property(readwrite, retain) NSSet *population;
@property(readwrite, retain) NSSet *deaths;
@property(readwrite, retain) NSSet *births;
@property(readwrite, retain) NSSet *mortalityAge;
@property(readwrite, retain) NSSet *averageAge;

@property(nonatomic, retain) NSSet *totalGenePresence;
@property(nonatomic, retain) NSCountedSet *accumulatedGenePresence;

- (void)updateTotalGenePresenceWithHashArrays:(NSArray *)geneHashes;

@end
