//
//  ALifeConfigurationViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _ALifeConfigurationControllerMode {
	kConfigurationControllerModeConfigure,
	kConfigurationControllerModeTinker
} ALifeConfigurationControllerMode;

@interface ALifeConfigurationViewController : NSViewController /*{
	NSMutableArray *optionControllers;
	Class <ALifeController> simulationClass;
	id <ALifeController> simulation;
	int contentHeight;
	ALifeConfigurationControllerMode mode;
}*/

@property (readonly) int contentHeight;

@property (nonatomic, strong) Class <ALifeController> simulationClass;
@property (nonatomic, assign) ALifeConfigurationControllerMode mode;
@property (nonatomic, strong) NSMutableArray *optionControllers;
@property (nonatomic, strong) id<ALifeController> simulation;

+ (ALifeConfigurationViewController *)configurationController;

- (NSDictionary *)configuration;
- (void)removeConfigurationControls;
- (void)addConfigurationControls;

@end
