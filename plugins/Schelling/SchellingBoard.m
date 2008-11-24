//
//  SchellingBoard.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SchellingBoard.h"
#import "SchellingSimulation.h"
#import "SchellingCell.h"

@implementation SchellingBoard

@synthesize game;

- (id)initWithFrame:(NSRect)frame {
    if (!(self = [super initWithFrame:frame]))
		return nil;
	
	game = nil;
	cellsa = nil;
	cellsb = nil;
	cellsc = nil;
	cellsd = nil;
	cellse = nil;
	lines = nil;
    
    return self;
}

- (void)dealloc;
{
	NSLog(@"Game: %d", [game retainCount]);
	self.game = nil;
	
	if (cellsa) free(cellsa);
	if (cellsb) free(cellsb);
	if (cellsc) free(cellsc);
	if (cellsd) free(cellsd);
	if (cellse) free(cellse);
	
	if (lines) free(lines);
	
	NSLog(@"Releasing board...");
	
	[super dealloc];
}

- (void)setGame:(SchellingSimulation *)myGame;
{
	if (game) {
		[game release];
	}
	game = [myGame retain];
	
	if (cellsa) free(cellsa);
	if (cellsb) free(cellsb);
	if (cellsc) free(cellsc);
	if (cellsd) free(cellsd);
	if (cellse) free(cellse);
	if (lines) free(lines);
	
	cellsa = malloc(game.width * game.height * sizeof(NSRect));
	cellsb = malloc(game.width * game.height * sizeof(NSRect));
	cellsc = malloc(game.width * game.height * sizeof(NSRect));
	cellsd = malloc(game.width * game.height * sizeof(NSRect));
	cellse = malloc(game.width * game.height * sizeof(NSRect));
	
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
	[[NSColor blackColor] set];
	NSRectFillList(lines, lineCount);
	
	// draw cells
	int cellCount = 0;
	SchellingCell *cell;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.race == 1) {
				cellsa[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor blueColor] set];
	NSRectFillList(cellsa, cellCount);
	//cells b
	cellCount = 0;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.race == 2) {
				cellsb[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor redColor] set];
	NSRectFillList(cellsb, cellCount);
	
	//cells c
	cellCount = 0;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.race == 3) {
				cellsc[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor greenColor] set];
	NSRectFillList(cellsc, cellCount);
	

	//cells d
	cellCount = 0;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.race == 4) {
				cellsd[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor magentaColor] set];
	NSRectFillList(cellsd, cellCount);
	
	//cells e
	cellCount = 0;
	for (i = 0; i < game.height; i++) {
		for (j = 0; j < game.width; j++) {
			cell = [[game.grid objectAtIndex:i] objectAtIndex:j];
			if (cell.race == 5) {
				cellse[cellCount] = NSMakeRect(cell.column * cellWidth, cell.row * cellHeight, cellWidth, cellHeight);
				cellCount++;
			}
		}
	}
	[[NSColor cyanColor] set];
	NSRectFillList(cellse, cellCount);
	
	[[NSColor darkGrayColor] set];
	NSRectFillList(lines, lineCount);
}

@end
