//
//  ALifeConfigurationWindowController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeConfigurationWindowController.h"

#import "ALifeWindowController.h"
#import "ALifeConfigurationViewController.h"

@implementation ALifeConfigurationWindowController

@synthesize configurationViewController, simulationClasses, selectedClassIndices;

+ (ALifeConfigurationWindowController *)configurationWindowController;
{
	return [[[self alloc] initWithWindowNibName:@"ConfigurationWindow"] autorelease];
}

- (id)initWithWindowNibName:(NSString *)windowNibName;
{
	if (!(self = [super initWithWindowNibName:windowNibName]))
		return nil;
	
	self.configurationViewController = [ALifeConfigurationViewController configurationController];
	
	[[self window] makeKeyAndOrderFront:self];
	
	return self;
}

- (void)awakeFromNib;
{
	[configurationViewController setView:scrollView.documentView];
}

- (void)dealloc;
{
	self.simulationClasses = nil;
	self.configurationViewController = nil;
	self.selectedClassIndices = nil;
	
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)notification;
{
	[self autorelease];
}

- (Class <ALifeController>)selectedClass;
{
	if ([selectedClassIndices count] > 0)
		return [[simulationClasses objectsAtIndexes:selectedClassIndices] objectAtIndex:0];
	else
		return nil;
}

- (NSIndexSet *)selectedClassIndices
{
    return selectedClassIndices;
}

- (void)setSelectedClassIndices:(NSIndexSet *)newIndices;
{
	[selectedClassIndices release];
	selectedClassIndices = [newIndices retain];
	if ([selectedClassIndices count] > 0)
		[self showConfiguration];
}

- (void)showConfiguration;
{
	// set configuration to current class
	configurationViewController.simulationClass = [self selectedClass];
	
	// have to defer this because of scroll view wierdness
	[configurationViewController addConfigurationControls];
	
	NSRect cFrame = configurationViewController.view.frame;
	if (cFrame.size.height < scrollView.contentSize.height)
		cFrame.size.height = scrollView.contentSize.height;
	configurationViewController.view.frame = cFrame;
	
	NSPoint newScrollOrigin=NSMakePoint(0.0,NSMaxY([[scrollView documentView] frame])
										-NSHeight([[scrollView contentView] bounds]));
	[[scrollView documentView] scrollPoint:newScrollOrigin];
}

- (IBAction)actionStartSimulation:(id)sender;
{
	// get configuration options
	NSDictionary *configuration = [configurationViewController configuration];
	
	// instantiate a simulation window controller with options
	ALifeWindowController *simulationWindow = [ALifeWindowController windowControllerForModel:[self selectedClass] withConfiguration:configuration];
	[simulationWindow.window makeKeyWindow];
	
	// close our window
	[[self window] close];
}

@end
