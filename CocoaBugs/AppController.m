//
//  AppController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "ALifeConfigurationWindowController.h";
#import "ALifeWindowController.h";
#import "ALifePluginLoader.h";

@implementation AppController

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	return self;
}

- (IBAction)showConfigurationWindow:(id)sender;
{
	ALifeConfigurationWindowController *windowController = [ALifeConfigurationWindowController configurationWindowController];
	windowController.simulationClasses = [ALifePluginLoader allPlugIns];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:filename];
	
	NSString *identifier = [data objectForKey:@"identifier"];
	NSDictionary *configuration = [data objectForKey:@"configuration"];
	
	Class selectedPlugin;
	NSArray *plugins = [ALifePluginLoader allPlugIns];
	for (Class <ALifeController> plugin in plugins) {
		if ([[plugin name] isEqual:identifier]) {
			selectedPlugin = plugin;
			break;
		}
	}
	
	ALifeWindowController *simulationWindow = [ALifeWindowController windowControllerForModel:selectedPlugin withConfiguration:configuration];

	return YES;
}

@end
