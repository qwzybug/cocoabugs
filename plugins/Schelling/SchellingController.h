//
//  SchellingController.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SchellingSimulation, SchellingBoard, SchellingStatistics;

@interface SchellingController : NSObject <ALifeController> {
	SchellingBoard *board;
	SchellingSimulation *game;
	NSDictionary *properties;
	SchellingStatistics *statisticsCollector;
}

@property(readonly) NSDictionary *properties;
@property(readonly) SchellingStatistics *statisticsCollector;

+ (NSString *)name;

@end
