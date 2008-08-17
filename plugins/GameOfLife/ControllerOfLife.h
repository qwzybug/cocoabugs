//
//  ControllerOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALifeController.h"

@class GameOfLife, BoardOfLife, StatisticsOfLife;

@interface ControllerOfLife : NSObject <ALifeController> {
	BoardOfLife *board;
	GameOfLife *game;
	NSDictionary *properties;
	StatisticsOfLife *statisticsCollector;
}

@property(readonly) NSDictionary *properties;
@property(readonly) StatisticsOfLife *statisticsCollector;

+ (NSString *)name;

@end
