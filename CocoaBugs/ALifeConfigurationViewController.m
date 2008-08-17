//
//  ALifeConfigurationViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeConfigurationViewController.h"

#import "IntegerOptionViewController.h"
#import "FloatOptionViewController.h"

@implementation ALifeConfigurationViewController

@synthesize simulationClass, contentHeight;

+ (ALifeConfigurationViewController *)configurationController;
{
	return [[[self alloc] initWithNibName:@"ConfigurationView" bundle:[NSBundle mainBundle]] autorelease];
}

- (void)dealloc;
{
	[optionControllers release]; optionControllers = nil;
	
	[super dealloc];
}

- (void)setSimulationClass:(Class <ALifeController>)newSimulationClass;
{
	simulationClass = newSimulationClass;
	
	// this should release the option controllers and remove their views...?
	[optionControllers release];
	optionControllers = [[NSMutableArray arrayWithCapacity:5] retain];
	
	// create the option controllers
	NSArray *configuration = [simulationClass configurationOptions];
	for (NSDictionary *options in configuration) {
		if ([[options objectForKey:@"type"] isEqual:@"Integer"]) {
			[optionControllers addObject:[IntegerOptionViewController controllerWithOptions:options]];
		} else if ([[options objectForKey:@"type"] isEqual:@"Float"]) {
			[optionControllers addObject:[FloatOptionViewController controllerWithOptions:options]];
		}
	}
	contentHeight = [optionControllers count] * 64.0;
	
	// resize view
	NSRect currentFrame = self.view.frame;
	currentFrame.size.height = contentHeight;
	[self.view setFrame:currentFrame];
}

- (void)addConfigurationControls;
{
	float currentHeight = contentHeight;

	NSRect currentFrame = self.view.frame;

	// add views
	for (NSViewController *viewController in optionControllers) {
		currentHeight -= 64.0;
		NSView *optionView = [viewController view];
		optionView.frame = NSMakeRect(10.0, currentHeight, currentFrame.size.width - 20.0, 64.0);
		[self.view addSubview:optionView];
	}
}

- (NSDictionary *)configuration;
{
	NSMutableDictionary *configurationDict = [NSMutableDictionary dictionary];
	for (IntegerOptionViewController *viewController in optionControllers) {
		[configurationDict setObject:[viewController value] forKey:[viewController name]];
	}
	return configurationDict;
}

@end
