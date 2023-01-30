//
//  BugsColoringWindowController.h
//  Packard Bugs Plugin
//
//  Created by Devin Chalmers on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BugsController;
@class GeneDistributionView;
@class BugNeighborhoodView;

@interface BugsColoringWindowController : NSWindowController {
	BugsController *controller;
	
	IBOutlet GeneDistributionView *distributionView;
	IBOutlet BugNeighborhoodView *neighborhoodView;
	
	NSDate *lastDistributionDisplay;
}

@property (nonatomic, strong) BugsController *controller;
@property (nonatomic, strong) NSDate *lastDistributionDisplay;

- (void)setGene:(int)newGene;
- (void)updateDistributionView;

@end
