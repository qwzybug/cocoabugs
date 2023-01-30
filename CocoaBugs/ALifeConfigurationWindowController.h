//
//  ALifeConfigurationWindowController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Bugs/ALifeController.h>

@class ALifeConfigurationWindowController, ALifeConfigurationViewController, ALifeController;

@protocol ALifeConfigurationControllerDelegate
- (void)configurationController:(ALifeConfigurationWindowController *)controller didCompleteWithSimulationClass:(Class <ALifeController>)simulationClass configuration:(NSDictionary *)configuration;
@end

@interface ALifeConfigurationWindowController : NSWindowController {
	ALifeConfigurationViewController *configurationViewController;
	NSMutableArray *simulationClasses;
	NSIndexSet *selectedClassIndices;
	
	IBOutlet NSView *configurationView;
	IBOutlet NSScrollView *scrollView;
}

@property (nonatomic, strong) ALifeConfigurationViewController *configurationViewController;
@property (nonatomic, strong) NSMutableArray *simulationClasses;
@property (nonatomic, strong) NSIndexSet *selectedClassIndices;

@property (nonatomic, weak) id<ALifeConfigurationControllerDelegate> delegate;

+ (ALifeConfigurationWindowController *)configurationWindowController;

- (void)showConfiguration;

- (IBAction)actionStartSimulation:(id)sender;

@end
