//
//  ALifeConfigurationViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

typedef enum _ALifeConfigurationControllerMode {
	kConfigurationControllerModeConfigure,
	kConfigurationControllerModeTinker
} ALifeConfigurationControllerMode;

@interface ALifeConfigurationViewController : NSViewController {
	NSMutableArray *optionControllers;
	Class <ALifeController> simulationClass;
	id <ALifeController> simulation;
	int contentHeight;
	ALifeConfigurationControllerMode mode;
}

@property(readwrite) Class <ALifeController> simulationClass;
@property(readonly) int contentHeight;
@property (nonatomic, assign) ALifeConfigurationControllerMode mode;
@property (nonatomic, retain) NSMutableArray *optionControllers;
@property (nonatomic, retain) id<ALifeController> simulation;

+ (ALifeConfigurationViewController *)configurationController;

- (NSDictionary *)configuration;
- (void)removeConfigurationControls;
- (void)addConfigurationControls;

@end
