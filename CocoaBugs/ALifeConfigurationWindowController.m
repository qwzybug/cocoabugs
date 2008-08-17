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
	return [[self alloc] initWithWindowNibName:@"ConfigurationWindow"];
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
//	[configurationView addSubview:configurationViewController.view];
	NSSize contentSize = scrollView.contentSize;
//	NSRect configFrame = configurationViewController.view.frame;
//	configFrame.size.width = 
//	configurationViewController.view.frame = scrollView.frame;
//	[scrollView setDocumentView:configurationViewController.view];
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

//- (void)windowDidResize:(NSNotification *)notification
//{
//	NSRect cFrame = configurationViewController.view.frame;
//	configurationViewController.view.frame = cFrame;
//}

- (IBAction)actionStartSimulation:(id)sender;
{
	// get configuration options
	NSDictionary *configuration = [configurationViewController configuration];
	NSLog([configuration description]);
	// instantiate a simulation window controller with options
	ALifeWindowController *simulationWindow = [ALifeWindowController windowControllerForModel:[self selectedClass] withConfiguration:configuration];
	// close our window
	[[self window] close];
}

- (IBAction)actionExportConfiguration:(id)sender;
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setRequiredFileType:@"cocoabugs"];
	[savePanel beginSheetForDirectory:nil file:nil modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
{
	if (returnCode == NSOKButton) {
		NSDictionary *configuration = [configurationViewController configuration];
		NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[[self selectedClass] name], @"identifier", configuration, @"configuration", nil];
		[data writeToFile:[sheet filename] atomically:YES];
	}
}

@end
