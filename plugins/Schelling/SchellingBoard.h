//
//  SchellingBoard.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SchellingSimulation;

@interface SchellingBoard : NSView {
	SchellingSimulation *game;
	
	NSRect *lines;
	NSRect *cellsa;
	NSRect *cellsb;
	NSRect *cellsc;
	NSRect *cellsd;
	NSRect *cellse;
}

@property(readwrite, strong) SchellingSimulation *game;

@end
