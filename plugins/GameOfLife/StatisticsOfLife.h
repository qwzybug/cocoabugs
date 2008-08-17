//
//  StatisticsOfLife.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GameOfLife;

@interface StatisticsOfLife : NSObject {
	NSSet *population;
	GameOfLife *game;
}

@property(readwrite, retain) NSSet *population;
@property(readwrite, retain) GameOfLife *game;

- (id)initWithGame:(id)theGame;
- (void)updateStatistics;

@end
