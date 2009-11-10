//
//  SchellingController.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SchellingController.h"
#import "SchellingSimulation.h"
#import "SchellingCell.h"
#import "SchellingBoard.h"
#import "SchellingStatistics.h"

@implementation SchellingController

@synthesize statisticsCollector, properties, game;

+ (NSString *)name;
{
	return @"Schelling's Segregation";
}

+ (NSArray *)configurationOptions;
{
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Schelling" ofType:@"plist"];
	NSDictionary *propDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	return [propDict objectForKey:@"configuration"];
}

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	int gameSize = [[configuration objectForKey:@"size"] intValue];
	int width = gameSize, height = gameSize;
	
	
	game = [[SchellingSimulation alloc] initWithWidth:width height:height];
	
	game.raceCount = [[configuration objectForKey:@"raceCount"] intValue];
	game.initialPopulationDensity = [[configuration objectForKey:@"popDensity"] floatValue];
	
	game.zero = [[configuration objectForKey:@"zero"] intValue];
	game.one = [[configuration objectForKey:@"one"] intValue];
	game.two = [[configuration objectForKey:@"two"] intValue];
	game.three = [[configuration objectForKey:@"three"] intValue];
	game.four = [[configuration objectForKey:@"four"] intValue];
	game.five = [[configuration objectForKey:@"five"] intValue];
	game.six = [[configuration objectForKey:@"six"] intValue];
	game.seven = [[configuration objectForKey:@"seven"] intValue];
	game.eight = [[configuration objectForKey:@"eight"] intValue];
	
	[game seed];
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Schelling" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	statisticsCollector = [[SchellingStatistics alloc] initWithGame:game];
	
	return self;
}

- (void)dealloc;
{
	[properties release];
	[statisticsCollector release];
	[board release];
	[game release];
	
	[super dealloc];
}

- (void)reset;
{
	[game seed];
	[board setNeedsDisplay:YES];
}

- (NSView *)view;
{
#define MAX_BOARD_DIMENSION 800
#define MAX_PIXEL_SIZE 5
	if (!board) {
		int max_dimension = MAX(game.width, game.height);
		int pixel_size = MAX_BOARD_DIMENSION / max_dimension > MAX_PIXEL_SIZE ? MAX_PIXEL_SIZE : MAX_BOARD_DIMENSION / max_dimension;
		board = [[SchellingBoard alloc] initWithFrame:NSMakeRect(0, 0, pixel_size * game.width, pixel_size * game.height)];
		board.game = game;
	}
	return board;
}

- (void)update;
{
	[game update];
	[statisticsCollector updateStatistics];
	[board setNeedsDisplay:YES];
}

#pragma mark -

- (void)showColorWindow;
{
	NSLog(@"No coloring window for Schelling yet.");
}

- (BOOL)alive;
{
	return YES;
}

- (void)setCollectActivity:(BOOL)collectActivity;
{
	// noop
}

- (void)exportActivity:(NSString *)path;
{
	// noop
}

- (NSString *)stepKeyPath;
{
	return @"game.generation";
}

@end
