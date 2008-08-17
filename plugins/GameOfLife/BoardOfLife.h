//
//  BoardOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GameOfLife;

@interface BoardOfLife : NSView {
	GameOfLife *game;
	
	NSRect *lines;
	NSRect *cells;
}

@property(readwrite, retain) GameOfLife *game;

@end
