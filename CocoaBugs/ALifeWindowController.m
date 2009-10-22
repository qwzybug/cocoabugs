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
#import "ALifeTinkerPanelController.h"
#import "DMQuicktimeExporter.h"

@implementation ALifeWindowController

@synthesize simulationController, running, recording, movieExporter;

+ (id)windowControllerForModel:(Class <ALifeController>)lifeController withConfiguration:(NSDictionary *)configuration;
{
	return [[self alloc] initWithSimulationClass:lifeController configuration:configuration];
}

- (void)dealloc;
{
	self.simulationController = nil;
	
	[super dealloc];
}

- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;
{
	if (!(self = [super initWithWindowNibName:@"ALifeWindow"]))
		return nil;
	
	simulationController = [[ALifeSimulationController alloc] initWithSimulationClass:modelClass configuration:configuration];
	
	tinkerPanelController = [[ALifeTinkerPanelController tinkerPanelForSimulation:simulationController.lifeController] retain];
	
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

- (IBAction)showConfigurationWindow:(id)sender;
{
	[[tinkerPanelController window] makeKeyAndOrderFront:self];
}

- (IBAction)showColoringWindow:(id)sender;
{
	[simulationController.lifeController showColorWindow];
}

- (IBAction)tick:(id)sender;
{
	[self stepSimulation];
}

- (void)stepSimulation;
{
	[simulationController.lifeController update];
	if (recording) {
		[self.movieExporter addFrame];
	}
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
	self.running = NO;
	[self autorelease];
}

- (void)setRecording:(BOOL)isRecording;
{
	if (isRecording) {
		self.movieExporter = [DMQuicktimeExporter movieExporterForView:[self.window contentView]];
		recording = YES;
		if (!running) {
			self.running = YES;
			[self tick:self];
		}
	} else {
		self.running = NO;
		[self exportMovie:self];
	}
}

- (IBAction)exportMovie:(id)sender;
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setAllowedFileTypes:[NSArray arrayWithObject:@"mov"]];
	[panel beginSheetForDirectory:nil file:nil modalForWindow:self.window modalDelegate:self didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
{
	if (returnCode == NSOKButton)
		[self.movieExporter exportMovie:[sheet filename]];
	
	self.movieExporter = nil;
}


@end
