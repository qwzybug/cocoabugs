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
}

@property (nonatomic, retain) BugsController *controller;

- (IBAction)setGene:(id)sender;

@end
