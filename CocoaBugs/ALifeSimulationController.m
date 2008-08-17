//
//  ALifeSimulationController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeSimulationController.h"

#import "ALifeShuffler.h"

@implementation ALifeSimulationController

@synthesize lifeController, configuration;

- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)theConfiguration;
{
	if (!(self = [super init]))
		return nil;
	
	NSArray *opts = [modelClass configurationOptions];
	
	NSLog(@"Initializing...");
	
	// check for shuffled parameters
	for (NSDictionary *configurationOptions in opts) {
		NSString *type = [configurationOptions objectForKey:@"type"];
		NSString *name = [configurationOptions objectForKey:@"name"];
		id entry = [theConfiguration objectForKey:name];
		if ([entry respondsToSelector:@selector(objectForKey:)]
			&& [entry objectForKey:@"shuffle"]) {
			[theConfiguration setValue:[ALifeShuffler shuffleType:type withOptions:entry] forKey:name];
		}
	}
	lifeController = [[modelClass alloc] initWithConfiguration:theConfiguration];
	self.configuration = [NSDictionary dictionaryWithDictionary:theConfiguration];
	
	return self;
}

- (void)dealloc;
{
	self.lifeController = nil;
	self.configuration = nil;
	
	[super dealloc];
}

@end
