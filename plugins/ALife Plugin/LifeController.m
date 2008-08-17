//
//  LifeController.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LifeController.h"

#import "LifeModel.h"
#import "LifeView.h"
#import "LifeController.h"
#import "StatisticsCollector.h"

@implementation LifeController

@synthesize properties;

+ (NSString *)name;
{
	return @"My ALife model";
}

+ (NSDictionary *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ALifePlugin" ofType:@"plist"];
	NSDictionary *propDict = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	return [propDict objectForKey:@"configuration"];
}

#pragma mark -

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	int favoriteNumber;
	if (configuration) {
		favoriteNumber = [[configuration objectForKey:@"favoriteNumber"] intValue];
	} else {
		favoriteNumber = 5;
	}
	
	simulation = [[LifeModel alloc] initWithFavoriteNumber:favoriteNumber];
	
	statistics = [[StatisticsCollector alloc] initWithSimulation:simulation];
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ALifePlugin" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing controller...");
	NSLog(@"Stats: %d", [statistics retainCount]);
	NSLog(@"Sim: %d", [simulation retainCount]);
	NSLog(@"View: %d", [view retainCount]);
	[statistics release];
	[view release];
	[simulation release];
	NSLog(@"Stats: %d", [statistics retainCount]);
	
	[super dealloc];
}

#pragma mark -

- (NSView *)view;
{
	if (!view) {
		view = [[LifeView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
		[view setSimulation:simulation];
	}
	return view;
}

- (void)update;
{
	[simulation update];
	[view setNeedsDisplay:YES];
}

- (id)statisticsCollector;
{
	return statistics;
}


@end
