//
//  ALifeRunExporter.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ALifeSimulationController, StatisticsController;

@interface ALifeRunExporter : NSObject {

}

+ (void)exportSimulation:(ALifeSimulationController *)simulationController withStatistics:(StatisticsController *)statisticsController toDirectory:(NSString *)path;

@end
