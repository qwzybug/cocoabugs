//
//  BugsController.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BugsController.h"

#import "World.h"
#import "WorldView.h"
#import "BugsStatistics.h"

@implementation BugsController

@synthesize properties;

+ (NSString *)name;
{
	return @"Packard's Bugs";
}

+ (NSDictionary *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PackardBugs" ofType:@"plist"];
	NSDictionary *propDict = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	return [propDict objectForKey:@"configuration"];
}

#pragma mark -

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	NSLog([configuration description]);
	
	int width = 100;
	int height = 100;
	float populationDensity = 0.5;
	if (configuration) {
		width = [[configuration objectForKey:@"width"] intValue];
		height = [[configuration objectForKey:@"height"] intValue];
		populationDensity = [[configuration objectForKey:@"populationDensity"] floatValue];
	}
	
	world = [[World alloc] initWithWidth:width andHeight:height];
	[world seedBugsWithDensity:populationDensity];
	
	if (configuration) {
		world.mutationRate = [[configuration objectForKey:@"mutationRate"] floatValue];
		world.reproductionFood = [[configuration objectForKey:@"reproductionFood"] intValue];
		world.movementCost = [[configuration objectForKey:@"movementCost"] intValue];
		world.eatAmount = [[configuration objectForKey:@"eatAmount"] intValue];
	}
	
	statistics = [[BugsStatistics alloc] initWithWorld:world];
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PackardBugs" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	return self;
}

- (void)dealloc;
{
	[world release];
	[statistics release];
	
	[super dealloc];
}

#pragma mark -

- (NSView *)view;
{
	if (!view) {
		view = [[WorldView alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
		view.world = world;
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
