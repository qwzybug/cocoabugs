//
//  ALifeWindowController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeWindowController.h"

#import "StatisticsController.h"
#import "ALifeSimulationController.h"

@implementation ALifeWindowController

@synthesize simulationController, running;

+ (id)windowControllerForModel:(Class <ALifeController>)lifeController withConfiguration:(NSDictionary *)configuration;
{
	return [[self alloc] initWithSimulationClass:lifeController configuration:configuration];
}

- (void)dealloc;
{
	NSLog(@"Deallocing window controller");
	NSLog(@"%d", [simulationController retainCount]);
	self.simulationController = nil;
	
	[super dealloc];
}

- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;
{
	if (!(self = [super initWithWindowNibName:@"ALifeWindow"]))
		return nil;
	
	simulationController = [[ALifeSimulationController alloc] initWithSimulationClass:modelClass configuration:configuration];
	
	NSView *contentView = [[self window] contentView];
	NSView *lifeView = [simulationController.lifeController view];
	NSRect contentFrame = contentView.frame;
	
	float deltaX = lifeView.frame.size.width - contentFrame.size.width;
	float deltaY = lifeView.frame.size.height - contentFrame.size.height;
	
	NSRect windowFrame = [[self window] frame];
	
	[[self window] setFrame:NSMakeRect(windowFrame.origin.x,
									   windowFrame.origin.y - deltaY,
									   windowFrame.size.width + deltaX,
									   windowFrame.size.height + deltaY)
					display:YES];
	
	
	[[self window] setContentView:lifeView];
	
	[statisticsController setSource:[simulationController.lifeController statisticsCollector]
					  forStatistics:[[simulationController.lifeController properties] objectForKey:@"statistics"]];	
	
	return self;
}

- (IBAction)tick:(id)sender;
{
	[self stepSimulation];
}

- (void)stepSimulation;
{
	[simulationController.lifeController update];
	if (running) {
		[self performSelector:@selector(stepSimulation)	withObject:nil afterDelay:0.02];
	}
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [[simulationController.lifeController class] name];
}

- (void)windowWillClose:(NSNotification *)notification;
{
	[self autorelease];
}

@end
