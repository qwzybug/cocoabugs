//
//  LifeController.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DaisyWorldController.h"

#import "DaisyWorld.h"
#import "DaisyWorldView.h"
#import "DaisyStatisticsCollector.h"

@implementation DaisyWorldController

@synthesize properties;

+ (NSString *)name;
{
	return @"DaisyWorld";
}

+ (NSArray *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"DaisyWorld" ofType:@"plist"];
	NSDictionary *propDict = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	return [propDict objectForKey:@"configuration"];
}

#pragma mark -

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
//	int favoriteNumber;
//	if (configuration) {
//		favoriteNumber = [[configuration objectForKey:@"favoriteNumber"] intValue];
//	} else {
//		favoriteNumber = 5;
//	}
	
	world = [[DaisyWorld alloc] init];
	
	statistics = [[DaisyStatisticsCollector alloc] initWithWorld:world];
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"DaisyWorld" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing controller...");
	NSLog(@"Stats: %d", [statistics retainCount]);
	NSLog(@"Sim: %d", [world retainCount]);
	NSLog(@"View: %d", [view retainCount]);
	[statistics release];
	[view release];
	[world release];
	NSLog(@"Stats: %d", [statistics retainCount]);
	
	[super dealloc];
}

#pragma mark -

- (NSView *)view;
{
	if (!view) {
		view = [[DaisyWorldView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
		[view setSimulation:world];
	}
	return view;
}

- (void)update;
{
	[world update];
	[view setNeedsDisplay:YES];
}

- (id)statisticsCollector;
{
	return statistics;
}


@end
