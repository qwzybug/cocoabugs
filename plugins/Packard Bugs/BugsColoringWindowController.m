//
//  BugsColoringWindowController.m
//  Packard Bugs Plugin
//
//  Created by Devin Chalmers on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BugsColoringWindowController.h"

#import "BugsController.h"
#import "GeneDistributionView.h"
#import "BugNeighborhoodView.h"

@implementation BugsColoringWindowController

@synthesize controller;

- (IBAction)setGene:(id)sender;
{
	NSLog(@"Coloring by %d", neighborhoodView.neighborhoodCode);
	((BugsController *)controller).observedGene = neighborhoodView.neighborhoodCode;
	[controller redrawDisplay];
	[distributionView setNeedsDisplay:YES];
}

@end
