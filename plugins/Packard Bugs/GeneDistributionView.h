//
//  GeneDistributionView.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "World.h"
#import "BugNeighborhoodView.h"
#import "Cell.h"
#import "Bug.h"

@interface GeneDistributionView : NSView {
	IBOutlet BugNeighborhoodView *neighborhoodView;
	
	int gene;
	bool needsRedisplay;
	int geneCounts[31][31];
	
	NSSet *bugs;
}

- (void)timerTick:(NSTimer *)theTimer;

@property (nonatomic, strong) NSSet *bugs;
@property (nonatomic, assign) int gene;

@end
