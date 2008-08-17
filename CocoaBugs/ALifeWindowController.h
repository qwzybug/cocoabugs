//
//  ALifeWindowController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@class StatisticsController;

@interface ALifeWindowController : NSWindowController {
	id <ALifeController> simulationController;
	IBOutlet StatisticsController *statisticsController;
	
	BOOL running;
}

@property(readwrite, retain) id <ALifeController> simulationController;
@property(readwrite, assign) BOOL running;

+ (id)windowControllerForModel:(Class <ALifeController>)lifeController withConfiguration:(NSDictionary *)configuration;
- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;

- (IBAction)tick:(id)sender;
- (void)stepSimulation;

@end