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
	NSSet *segregation;
	NSSet *diversity;
	SchellingSimulation *game;
}

@property(readwrite, retain) NSSet *segregation;
@property(readwrite, retain) NSSet *diversity;
@property(readwrite, retain) SchellingSimulation *game;

- (id)initWithGame:(id)theGame;
- (void)updateStatistics;

@end
