//
//  ALifeWindowController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@class StatisticsController, ALifeSimulationController, DMQuicktimeExporter, ALifeTinkerPanelController;

@interface ALifeWindowController : NSWindowController {
	IBOutlet StatisticsController *statisticsController;
	ALifeTinkerPanelController *tinkerPanelController;
	ALifeSimulationController *simulationController;
	DMQuicktimeExporter *movieExporter;
	
	BOOL running;
	BOOL recording;
}

@property(readwrite, assign) BOOL running;
@property(readwrite, assign) BOOL recording;
@property(readwrite, retain) ALifeSimulationController *simulationController;
@property(readwrite, retain) DMQuicktimeExporter *movieExporter;

+ (id)windowControllerForModel:(Class <ALifeController>)lifeController withConfiguration:(NSDictionary *)configuration;
- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;

- (IBAction)tick:(id)sender;
- (void)stepSimulation;
- (IBAction)exportMovie:(id)sender;

- (IBAction)showConfigurationWindow:(id)sender;
- (IBAction)showColoringWindow:(id)sender;

@end
