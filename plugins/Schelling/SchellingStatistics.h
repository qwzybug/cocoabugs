//
//  SchellingStatistics.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SchellingSimulation;

@interface SchellingStatistics : NSObject {
	NSSet *population;
	SchellingSimulation *game;
}

@property(readwrite, retain) NSSet *population;
@property(readwrite, retain) SchellingSimulation *game;

- (id)initWithGame:(id)theGame;
- (void)updateStatistics;

@end
