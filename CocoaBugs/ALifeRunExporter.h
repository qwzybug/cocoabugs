//
//  ALifeRunExporter.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@class StatisticsController;

@interface ALifeRunExporter : NSObject {

}

+ (void)exportSimulation:(id <ALifeController>)simulation withStatistics:(StatisticsController *)statisticsController toFilePath:(NSString *)path;

@end
