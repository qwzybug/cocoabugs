//
//  ALifeWindowController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeWindowController.h"

#import "StatisticsController.h"
#import "ALifeShuffler.h"

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
	
	NSArray *opts = [modelClass configurationOptions];
	
	NSLog(@"Initializing...");
	
	// check for shuffled parameters
	for (NSDictionary *configurationOptions in opts) {
		NSString *type = [configurationOptions objectForKey:@"type"];
		NSString *name = [configurationOptions objectForKey:@"name"];
		id entry = [configuration objectForKey:name];
		if ([entry respondsToSelector:@selector(objectForKey:)]
			&& [entry objectForKey:@"shuffle"]) {
			[configuration setValue:[ALifeShuffler shuffleType:type withOptions:entry] forKey:name];
		}
	}
	simulationController = [[modelClass alloc] initWithConfiguration:configuration];
	
	NSView *contentView = [[self window] contentView];
	NSView *lifeView = [simulationController view];
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
	
	[statisticsController setSource:[simulationController statisticsCollector]
					  forStatistics:[[simulationController properties] objectForKey:@"statistics"]];
	
	return self;
}

- (IBAction)tick:(id)sender;
{
	[self stepSimulation];
}

- (void)stepSimulation;
{
	[simulationController update];
	if (running) {
		[self performSelector:@selector(stepSimulation)	withObject:nil afterDelay:0.02];
	}
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [[simulationController class] name];
}

- (void)windowWillClose:(NSNotification *)notification;
{
	[self autorelease];
}

@end
