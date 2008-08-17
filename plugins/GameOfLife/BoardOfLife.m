//
//  BoardOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoardOfLife.h"
#import "GameOfLife.h"
#import "CellOfLife.h"

@implementation BoardOfLife

@synthesize game;

- (id)initWithFrame:(NSRect)frame {
    if (!(self = [super initWithFrame:frame]))
		return nil;
	
	game = nil;
	cells = nil;
	lines = nil;
    
    return self;
}

- (void)dealloc;
{
	NSLog(@"Game: %d", [game retainCount]);
	self.game = nil;
	
	if (cells) free(cells);
	if (lines) free(lines);
	
	NSLog(@"Releasing board...");
	
	[super dealloc];
}

- (void)setGame:(GameOfLife *)myGame;
{
	if (game) {
		[game release];
	}
	game = [myGame retain];
	
	if (cells) free(cells);
	if (lines) free(lines);
	
	cells = malloc(game.width * game.height * sizeof(NSRect));
	lines = malloc((game.width + game.height - 1) * sizeof(NSRect));
}

- (void)drawRect:(NSRect)rect {
	if (!game)
		return;
	
	int i, j;

	float cellWidth = [self frame].size.width / game.width;
	float cellHeight = [self frame].size.height / game.height;
	
	// draw grid lines
	int lineCount = 0;
	for (i = 0; i < game.height; i++) {
		lines[lineCount] = NSMakeRect(0, i * cellHeight, [self frame].size.width, 1);
		lineCount++;
	}
	for (i = 1; i < game.width; i++) {
		lines[lineCount] = NSMakeRect(i * cellWidth, 0, 1, [self frame].size.height);
		lineCount++;
	}
	[[NSColor grayColor] set];
	NSRectFillList(lines, lineCount);
	
	// draw cells
	int cellCount = 0;
	CellOfLife *cell;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.alive) {
				cells[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor blackColor] set];
	NSRectFillList(cells, cellCount);
}

@end
