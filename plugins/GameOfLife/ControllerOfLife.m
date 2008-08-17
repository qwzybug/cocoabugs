//
//  ControllerOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ControllerOfLife.h"
#import "GameOfLife.h"
#import "BoardOfLife.h"
#import "StatisticsOfLife.h"

@implementation ControllerOfLife

@synthesize statisticsCollector, properties;

+ (NSString *)name;
{
	return @"Conway's Game of Life";
}

+ (NSDictionary *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"GameOfLife" ofType:@"plist"];
	NSDictionary *propDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	return [propDict objectForKey:@"configuration"];
}

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	int width, height;
	if (configuration) {
		width = [[configuration objectForKey:@"width"] intValue];
		height = [[configuration objectForKey:@"height"] intValue];
	} else {
		width = height = 150;
	}
	
	game = [[GameOfLife alloc] initWithWidth:width height:height];
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"GameOfLife" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	statisticsCollector = [[StatisticsOfLife alloc] initWithGame:game];
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Properties: %d", [properties retainCount]);
	NSLog(@"Board: %d", [board retainCount]);
	NSLog(@"Game: %d", [game retainCount]);

	[properties release];
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
