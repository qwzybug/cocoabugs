//
//  ControllerOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ControllerOfLife.h"
#import "GameOfLife.h"
#import "CellOfLife.h"
#import "BoardOfLife.h"
#import "StatisticsOfLife.h"

@implementation ControllerOfLife

@synthesize statisticsCollector, properties;

+ (NSString *)name;
{
	return @"Conway's Game of Life";
}

+ (NSArray *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"GameOfLife" ofType:@"plist"];
	NSDictionary *propDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	return [propDict objectForKey:@"configuration"];
}

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	int width = 100, height = 100;
	NSImage *worldImage = nil;
	if (configuration) {
		NSData *data = [configuration objectForKey:@"world"];
		if (data) {
			NSLog(@"Huh?");
			worldImage = [[[NSImage alloc] initWithData:data] autorelease];
			width = [worldImage size].width;
			height = [worldImage size].height;
		}
	}
	
	game = [[GameOfLife alloc] initWithWidth:width height:height];
	
	if (worldImage) {
		NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[worldImage TIFFRepresentation]];
		int i, j;
		BOOL sample;
		for (i = 0; i < height; i++) {
			for (j = 0; j < width; j++) {
				sample = [[bitmap colorAtX:j y:(height - i - 1)] brightnessComponent] < 0.5;
				if (sample)
					[game cellAtRow:i column:j].alive = YES;
			}
		}
		[game initGameOperations];
	}
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"GameOfLife" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	statisticsCollector = [[StatisticsOfLife alloc] initWithGame:game];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing Game of Life controller");
	NSLog(@"Properties: %d", [properties retainCount]);
	NSLog(@"Board: %d", [board retainCount]);
	NSLog(@"Game: %d", [game retainCount]);

	[properties release];
	[statisticsCollector release];
	[board release];
	[game release];
	
	[super dealloc];
}

- (NSView *)view;
{
#define MAX_BOARD_DIMENSION 800
#define MAX_PIXEL_SIZE 5
	if (!board) {
		int max_dimension = MAX(game.width, game.height);
		int pixel_size = MAX_BOARD_DIMENSION / max_dimension > MAX_PIXEL_SIZE ? MAX_PIXEL_SIZE : MAX_BOARD_DIMENSION / max_dimension;
		board = [[BoardOfLife alloc] initWithFrame:NSMakeRect(0, 0, pixel_size * game.width, pixel_size * game.height)];
		board.game = game;
	}
	return board;
}

- (void)update;
{
	[game update];
	[board setNeedsDisplay:YES];
}

@end
