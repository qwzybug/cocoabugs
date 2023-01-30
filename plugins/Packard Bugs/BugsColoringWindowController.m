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
@synthesize lastDistributionDisplay;

- (void)dealloc;
{
	lastDistributionDisplay = nil;
	controller = nil;
	
}

- (void)setGene:(int)newGene;
{
	controller.observedGene = newGene;
	distributionView.gene = newGene;
	[self updateDistributionView];
}

- (void)awakeFromNib;
{
	self.lastDistributionDisplay = [NSDate date];
	[controller.world addObserver:self forKeyPath:@"ticks" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateDistributionView;
{
	distributionView.bugs = controller.world.bugs;
	[distributionView setNeedsDisplay:YES];
	self.lastDistributionDisplay = [NSDate date];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([keyPath isEqual:@"ticks"] && [[NSDate date] timeIntervalSinceDate:self.lastDistributionDisplay] > 0.5) {
		[self updateDistributionView];
	}
}

@end
