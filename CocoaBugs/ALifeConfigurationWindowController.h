//
//  ALifeConfigurationWindowController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@class ALifeConfigurationViewController;

@interface ALifeConfigurationWindowController : NSWindowController {
	ALifeConfigurationViewController *configurationViewController;
	NSMutableArray *simulationClasses;
	NSIndexSet *selectedClassIndices;
	
	IBOutlet NSView *configurationView;
	IBOutlet NSScrollView *scrollView;
}

@property(readwrite, retain) ALifeConfigurationViewController *configurationViewController;
@property(readwrite, retain) NSMutableArray *simulationClasses;
@property(readwrite, retain) NSIndexSet *selectedClassIndices;

+ (ALifeConfigurationWindowController *)configurationWindowController;

- (void)showConfiguration;

- (IBAction)actionStartSimulation:(id)sender;

@end
