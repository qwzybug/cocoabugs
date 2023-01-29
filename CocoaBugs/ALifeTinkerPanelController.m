//
//  ALifeTinkerPanelController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ALifeTinkerPanelController.h"

#import "ALifeConfigurationViewController.h"

#import "FloatOptionViewController.h"

@implementation ALifeTinkerPanelController

@synthesize configurationViewController;

+ (ALifeTinkerPanelController *)tinkerPanelForSimulation:(id<ALifeController>)simulation;
{
	return [[self alloc] initWithSimulation:simulation];
}

- (id)initWithSimulation:(id<ALifeController>)inSimulation;
{
	if (!(self = [super initWithWindowNibName:@"TinkerPanel"]))
		return nil;
	
	simulation = inSimulation;
	
	return self;
}

- (void)awakeFromNib;
{
	self.configurationViewController.mode = kConfigurationControllerModeTinker;
	
	NSRect beforeFrame = configurationViewController.view.frame;
	
	self.configurationViewController.simulation = simulation;
	self.configurationViewController.simulationClass = [simulation class];
	[self.configurationViewController addConfigurationControls];
	
	NSRect afterFrame = configurationViewController.view.frame;
	NSRect wFrame = [[self window] frame];
	float delta = afterFrame.size.height - beforeFrame.size.height;
	wFrame.size.height += delta;
	wFrame.origin.y -= delta;
	[[self window] setFrame:wFrame display:YES];
	
	NSRect contentFrame = [[[self window] contentView] frame];
	[[self window] setContentMaxSize:NSMakeSize(1000, contentFrame.size.height)];
	[[self window] setContentMinSize:NSMakeSize(contentFrame.size.width, contentFrame.size.height)];
}

@end
