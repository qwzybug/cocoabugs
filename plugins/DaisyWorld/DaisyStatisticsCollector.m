//
//  StatisticsCollector.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DaisyStatisticsCollector.h"

#import "DaisyWorld.h"

@implementation DaisyStatisticsCollector

//@synthesize generation, currentNumber;

- (id)initWithWorld:(DaisyWorld *)theWorld;
{
	if (!(self = [super init]))
		return nil;
	
	world = [theWorld retain];
	
	[world addObserver:self forKeyPath:@"step" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

//- (void)dealloc;
//{
//	NSLog(@"Deallocing statistics collector");
//	[simulation removeObserver:self forKeyPath:@"generation"];
//	[simulation release];
//	
//	self.generation = nil;
//	self.currentNumber = nil;
//	
//	[super dealloc];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//					  ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//	if ([keyPath isEqual:@"generation"]) {
//		[self updateStatistics];
//	}
//}
//
//- (void)updateStatistics;
//{
//	// generation
//	self.generation = [NSSet setWithObject:[NSNumber numberWithInt:simulation.generation]];
//	self.currentNumber = [NSSet setWithObject:[NSNumber numberWithInt:((simulation.generation % simulation.favoriteNumber) + 1)]];
//}


@end
