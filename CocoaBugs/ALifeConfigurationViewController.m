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
	return [[self alloc] initWithNibName:@"ConfigurationView" bundle:[NSBundle mainBundle]];
}

- (void)dealloc;
{
	optionControllers = nil;
	simulation = nil;
}

- (void)setSimulationClass:(Class <ALifeController>)newSimulationClass;
{
	simulationClass = newSimulationClass;
	
	[self removeConfigurationControls];
	self.optionControllers = [NSMutableArray arrayWithCapacity:5];
	
	// create the option controllers
	NSArray *configuration = [simulationClass configurationOptions];
	for (NSDictionary *options in configuration) {
		NSString *keyPath = [options objectForKey:@"keyPath"];
		NSString *controllerKey = nil;
		NSViewController *controller = nil;
		id currentValue = [(NSObject *)simulation valueForKeyPath:keyPath];
		
		// if we're in tinker mode, we only want to add options with a key path
		if (self.mode == kConfigurationControllerModeTinker && !keyPath) {
			continue;
		}
		
		if ([[options objectForKey:@"type"] isEqual:@"Integer"]) {
			controller = [IntegerOptionViewController controllerWithOptions:options];
			controllerKey = @"value";
		} else if ([[options objectForKey:@"type"] isEqual:@"Float"]) {
			controller = [FloatOptionViewController controllerWithOptions:options];
			controllerKey = @"value";
		} else if ([[options objectForKey:@"type"] isEqual:@"Bitmap"]) {
			controller = [BitmapOptionViewController controllerWithOptions:options];
			controllerKey = @"image";
		}
		
		if (controller) {
			[optionControllers addObject:controller];
			[controller loadView];
			if (self.mode == kConfigurationControllerModeTinker && self.simulation && controllerKey) {
				[controller setValue:currentValue forKey:controllerKey];
				id boundObject = [(NSObject *)simulation valueForKeyPath:[keyPath majorKeyPath]];
				[boundObject bind:[keyPath lastKeyPathComponent]
						 toObject:controller
					  withKeyPath:controllerKey
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
