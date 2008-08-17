//
//  StatisticsCollector.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsCollector.h"

#import "LifeModel.h"

@implementation StatisticsCollector

@synthesize generation, currentNumber;

- (id)initWithSimulation:(LifeModel *)theSimulation;
{
	if (!(self = [super init]))
		return nil;
	
	simulation = [theSimulation retain];
	
	[simulation addObserver:self forKeyPath:@"generation" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing statistics collector");
	[simulation removeObserver:self forKeyPath:@"generation"];
	[simulation release];
	
	self.generation = nil;
	self.currentNumber = nil;
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([keyPath isEqual:@"generation"]) {
		[self updateStatistics];
	}
}

- (void)updateStatistics;
{
	// generation
	self.generation = [NSSet setWithObject:[NSNumber numberWithInt:simulation.generation]];
	self.currentNumber = [NSSet setWithObject:[NSNumber numberWithInt:((simulation.generation % simulation.favoriteNumber) + 1)]];
}


@end
