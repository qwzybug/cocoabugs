//
//  ALifeTinkerPanelController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@class ALifeConfigurationViewController;

@interface ALifeTinkerPanelController : NSWindowController {
	IBOutlet ALifeConfigurationViewController *configurationViewController;
	id<ALifeController> simulation;
}

@property (nonatomic, retain) IBOutlet ALifeConfigurationViewController *configurationViewController;

+ (ALifeTinkerPanelController *)tinkerPanelForSimulation:(id<ALifeController>)simulation;
- (id)initWithSimulation:(id<ALifeController>)inSimulation;

@end
