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

- (id)initWithSimulationClass:(Class <ALifeController, NSObject>)modelClass configuration:(NSDictionary *)theConfiguration;
{
	if (!(self = [super init]))
		return nil;
	
	int seed = [[theConfiguration objectForKey:@"seed"] intValue];
	srandom(seed);
	
    lifeController = [[modelClass alloc] initWithConfiguration:theConfiguration];
	self.configuration = [NSDictionary dictionaryWithDictionary:theConfiguration];
	
	return self;
}

+ (id)controllerWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration sampling:(NSDictionary *)sampling;
{
	NSArray *modelConfiguration = [modelClass configurationOptions];
	NSDictionary *configurationOptions = [NSDictionary dictionaryWithObjects:modelConfiguration forKeys:[modelConfiguration valueForKey:@"name"]];
	NSMutableDictionary *theConfiguration = [NSMutableDictionary dictionaryWithDictionary:configuration];
	
	// check for sampled parameter
	NSString *sampleKey;
	if (sampling && (sampleKey = [sampling objectForKey:@"key"])) {
		// check for invalid option
		NSDictionary *opts = nil;
		if (!(opts = [configurationOptions valueForKey:sampleKey])) {
			NSLog(@"Error! Invalid shuffle key '%@' (expected one of %@)",
				  sampleKey,
				  [[configurationOptions allKeys] componentsJoinedByString:@", "]);
			return nil;
		}
		
		NSNumber *minValue = [sampling valueForKey:@"minValue"];
		if (!minValue) minValue = [opts valueForKey:@"minValue"];
		
		NSNumber *maxValue = [sampling valueForKey:@"maxValue"];
		if (!maxValue) maxValue = [opts valueForKey:@"maxValue"];
		
		int seed = (int)(([[NSDate date] timeIntervalSinceReferenceDate] - (int)[[NSDate date] timeIntervalSinceReferenceDate]) * INT_MAX);
		srandom(seed);
		NSNumber *shuffledValue = [ALifeShuffler shuffleType:[opts objectForKey:@"type"] min:minValue max:maxValue];
		[theConfiguration setObject:shuffledValue forKey:sampleKey];
	}
	
	// lock down random seed
	if (![configuration objectForKey:@"seed"]) {
		int seed = (int)(([[NSDate date] timeIntervalSinceReferenceDate] - (int)[[NSDate date] timeIntervalSinceReferenceDate]) * INT_MAX);
		[theConfiguration setObject:[NSNumber numberWithInt:seed] forKey:@"seed"];
	}
	
	ALifeSimulationController *controller = [[self alloc] initWithSimulationClass:modelClass configuration:theConfiguration];
	return [controller autorelease];
}

- (void)dealloc;
{
	self.lifeController = nil;
	self.configuration = nil;
	
	[super dealloc];
}

@end
