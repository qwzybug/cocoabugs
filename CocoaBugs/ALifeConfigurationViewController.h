//
//  ALifeConfigurationViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@interface ALifeConfigurationViewController : NSViewController {
	NSMutableArray *optionControllers;
	Class <ALifeController> simulationClass;
	int contentHeight;
}

@property(readwrite) Class <ALifeController> simulationClass;
@property(readonly) int contentHeight;

+ (ALifeConfigurationViewController *)configurationController;

- (NSDictionary *)configuration;
- (void)addConfigurationControls;

@end
