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

#import "BugsColoringWindowController.h"

@implementation BugsController

@synthesize properties;
@synthesize world;
@synthesize observedGene;
@synthesize populationDensity;

+ (NSString *)name;
{
	return @"Packard's Bugs";
}

+ (NSArray *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PackardBugs" ofType:@"plist"];
	NSDictionary *propDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	return [propDict objectForKey:@"configuration"];
}

#pragma mark -

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	populationDensity = 0.5;
	NSImage *foodImage = nil;
	if (configuration) {
		populationDensity = [[configuration objectForKey:@"populationDensity"] floatValue];
		
		NSData *foodData = [configuration objectForKey:@"world"];
		if (foodData)
			foodImage = [[[NSImage alloc] initWithData:foodData] autorelease];
	}
	
	world = [[World alloc] initWithFoodImage:foodImage];
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
	[view release];
	
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

- (void)reset;
{
	[world exterminate];
	[world seedBugsWithDensity:self.populationDensity];
}

- (void)update;
{
	[world update];
	[view setNeedsDisplay:YES];
}

- (void)redrawDisplay;
{
	[view setNeedsDisplay:YES];
}

- (id)statisticsCollector;
{
	return statistics;
}

- (void)setObservedGene:(int)newObservedGene;
{
	observedGene = newObservedGene;
	self.view.colorGene = observedGene;
	[self.view setNeedsDisplay:YES];
}

#pragma mark -

- (void)showColorWindow;
{
	if (!coloringWindowController) {
		coloringWindowController = [[BugsColoringWindowController alloc] initWithWindowNibName:@"BugsColoringWindowController"];
		coloringWindowController.controller = self;
	}
	[coloringWindowController.window makeKeyAndOrderFront:self];
}

@end
