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
#import "BitmapOptionViewController.h"

@implementation ALifeConfigurationViewController

@synthesize simulationClass, contentHeight, mode, optionControllers, simulation;

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
	
	[self removeConfigurationControls];
	self.optionControllers = [[NSMutableArray arrayWithCapacity:5] retain];
	
	// create the option controllers
	NSArray *configuration = [simulationClass configurationOptions];
	for (NSDictionary *options in configuration) {
		// if we're in tinker mode, we only want to add options with a key path
		if (self.mode == kConfigurationControllerModeTinker && ![options objectForKey:@"keyPath"]) {
			continue;
		}	
		if ([[options objectForKey:@"type"] isEqual:@"Integer"]) {
			IntegerOptionViewController *controller = [IntegerOptionViewController controllerWithOptions:options];
			[optionControllers addObject:controller];
			[controller loadView];
			if (self.mode == kConfigurationControllerModeTinker && self.simulation) {
				NSString *keyPath = [options objectForKey:@"keyPath"];
				[controller.slider bind:@"value"
							   toObject:self.simulation
							withKeyPath:keyPath
								options:nil];
			}
		} else if ([[options objectForKey:@"type"] isEqual:@"Float"]) {
			FloatOptionViewController *controller = [FloatOptionViewController controllerWithOptions:options];
			[optionControllers addObject:controller];
			[controller loadView];
			if (self.mode == kConfigurationControllerModeTinker && self.simulation) {
				NSString *keyPath = [options objectForKey:@"keyPath"];
				[controller.slider bind:@"value"
							   toObject:self.simulation
							withKeyPath:keyPath
								options:nil];
			}
		} else if ([[options objectForKey:@"type"] isEqual:@"Bitmap"]) {
			BitmapOptionViewController *controller = [BitmapOptionViewController controllerWithOptions:options];
			[optionControllers addObject:controller];
			[controller loadView];
			if (self.mode == kConfigurationControllerModeTinker && self.simulation) {
				NSString *keyPath = [options objectForKey:@"keyPath"];
				[controller bind:@"image"
						toObject:simulation
					 withKeyPath:keyPath
						 options:nil];
			}
		}
	}
	contentHeight = [optionControllers count] * 64.0;
	
	// resize view
	NSRect currentFrame = self.view.frame;
	currentFrame.size.height = contentHeight;
	[self.view setFrame:currentFrame];
}

- (void)removeConfigurationControls;
{
	for (NSViewController *viewController in optionControllers) {
		[viewController.view removeFromSuperview];
	}
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
		if ([viewController value])
			[configurationDict setObject:[viewController value] forKey:[viewController name]];
	}
	return configurationDict;
}

@end
