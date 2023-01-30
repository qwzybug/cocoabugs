//
//  AppController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "ALifeConfigurationWindowController.h"
#import "ALifeWindowController.h"
#import "ALifePluginLoader.h"

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    self.windowControllers = [NSMutableArray array];
    
    [self showConfigurationWindow:self];
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
    
    if (selectedPlugin == nil) {
        return NO;
    }
    
    [self showSimulationWindowForModel:selectedPlugin configuration:configuration];
    return YES;
}

- (IBAction)showConfigurationWindow:(id)sender;
{
    ALifeConfigurationWindowController *configurationWindow = [ALifeConfigurationWindowController configurationWindowController];
    configurationWindow.simulationClasses = [ALifePluginLoader allPlugIns];
    configurationWindow.delegate = self;
    [configurationWindow.window makeKeyWindow];

    [self.windowControllers addObject:configurationWindow];
}

- (void)showSimulationWindowForModel:(Class <ALifeController>)simulationClass configuration:(NSDictionary *)configuration;
{
    ALifeWindowController *simulationWindow = [ALifeWindowController windowControllerForModel:simulationClass withConfiguration:configuration];
    simulationWindow.delegate = self;
    [simulationWindow.window makeKeyWindow];

    [self.windowControllers addObject:simulationWindow];
}

- (void)configurationController:(ALifeConfigurationWindowController *)controller didCompleteWithSimulationClass:(Class<ALifeController>)simulationClass configuration:(NSDictionary *)configuration;
{
    [self.windowControllers removeObject:controller];
    [self showSimulationWindowForModel:simulationClass configuration:configuration];
}

- (void)windowControllerDidClose:(ALifeWindowController *)controller;
{
    [self.windowControllers removeObject:controller];
}

@end
