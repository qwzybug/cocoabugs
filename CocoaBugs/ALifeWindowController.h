//
//  ALifeWindowController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StatisticsController, ALifeSimulationController, ALifeTinkerPanelController, ALifeWindowController;

@protocol ALifeWindowControllerDelegate
- (void)windowControllerDidClose:(ALifeWindowController *)controller;
@end

@interface ALifeWindowController : NSWindowController {
	IBOutlet StatisticsController *statisticsController;
	ALifeTinkerPanelController *tinkerPanelController;
	ALifeSimulationController *simulationController;
//	DMQuicktimeExporter *movieExporter;
	
	IBOutlet NSTextField *stepLabel;
	
	BOOL running;
	BOOL recording;
}

@property (nonatomic, weak) id<ALifeWindowControllerDelegate> delegate;

@property (nonatomic, assign) BOOL running;
@property (nonatomic, assign) BOOL recording;
@property (nonatomic, strong) ALifeSimulationController *simulationController;
//@property(readwrite, retain) DMQuicktimeExporter *movieExporter;

+ (id)windowControllerForModel:(Class <ALifeController>)lifeController withConfiguration:(NSDictionary *)configuration;
- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;

- (IBAction)tick:(id)sender;
- (void)stepSimulation;
- (IBAction)exportMovie:(id)sender;

- (IBAction)showConfigurationWindow:(id)sender;
- (IBAction)showColoringWindow:(id)sender;
- (IBAction)actionExportConfiguration:(id)sender;
- (IBAction)resetAction:(id)sender;

@end
