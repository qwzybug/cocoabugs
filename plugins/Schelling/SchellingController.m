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

@synthesize statisticsCollector, properties;

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
	//load movement prefs
	int zero,one,two,three,four,five,six,seven,eight;
	
	zero = [[configuration objectForKey:@"zero"] intValue];
	one = [[configuration objectForKey:@"one"] intValue];
	two = [[configuration objectForKey:@"two"] intValue];
	three = [[configuration objectForKey:@"three"] intValue];
	four = [[configuration objectForKey:@"four"] intValue];
	five = [[configuration objectForKey:@"five"] intValue];
	six = [[configuration objectForKey:@"six"] intValue];
	seven = [[configuration objectForKey:@"seven"] intValue];
	eight = [[configuration objectForKey:@"eight"] intValue];
	
	int gameSize;
	gameSize = [[configuration objectForKey:@"size"] intValue];
	int width = gameSize, height = gameSize;

	
	int popDensity;
	popDensity = [[configuration objectForKey:@"popDensity"]intValue];
//	
	game = [[SchellingSimulation alloc] initWithWidth:width height:height];
	int raceCount;
	raceCount = [[configuration objectForKey:@"raceCount"]intValue];
	//raceCount = 3;
	int i, j;
	for (i = 0; i < height; i++) {
		for (j = 0; j < width; j++) {
			if (popDensity > random() % 100){
				[game cellAtRow:i column:j].race = (1+(random() % raceCount));
				//set movement prefs

			}
			[game cellAtRow:i column:j].zero = zero;
			[game cellAtRow:i column:j].one = one;
			[game cellAtRow:i column:j].two = two;
			[game cellAtRow:i column:j].three = three;
			[game cellAtRow:i column:j].four = four;
			[game cellAtRow:i column:j].five = five;
			[game cellAtRow:i column:j].six = six;
			[game cellAtRow:i column:j].seven = seven;
			[game cellAtRow:i column:j].eight = eight;
		}
	}
	
	
	
	
	
	//NSImage *worldImage = nil;
//	if (configuration) {
//		NSData *data = [configuration objectForKey:@"world"];
//		if (data) {
//			NSLog(@"Huh?");
//			worldImage = [[[NSImage alloc] initWithData:data] autorelease];
//			width = [worldImage size].width;
//			height = [worldImage size].height;
//		}
//	}
//	
//	game = [[SchellingSimulation alloc] initWithWidth:width height:height];
//
//	
//	if (worldImage) {
//		NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[worldImage TIFFRepresentation]];
//		int i, j;
//		BOOL sample;
//		for (i = 0; i < height; i++) {
//			for (j = 0; j < width; j++) {
//				sample = ([[bitmap colorAtX:j y:(height - i - 1)] brightnessComponent] < 0.7) && ([[bitmap colorAtX:j y:(height - i - 1)] brightnessComponent] > 0.3) ;
//				if (sample)
//					[game cellAtRow:i column:j].race = 1;
//			}
//		}
//		for (i = 0; i < height; i++) {
//			for (j = 0; j < width; j++) {
//				sample = ([[bitmap colorAtX:j y:(height - i - 1)] brightnessComponent] < 0.2) ;
//				if (sample)
//					[game cellAtRow:i column:j].race = 2;
//			}
//		}
//		[game initGameOperations];
//	}
//	
	
	
	
	//	
//		game = [[SchellingSimulation alloc] initWithWidth:width height:height];
//		int raceCount;
//		raceCount = [[configuration objectForKey:@"races"]intValue];
//	raceCount = 3;
//		int i, j;
//		for (i = 0; i < height; i++) {
//			for (j = 0; j < width; j++) {
//					[game cellAtRow:i column:j].race = (random() % raceCount+1);
//			}
//		}
	//	
	//	
	
	
	
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Schelling" ofType:@"plist"];
	properties = [[NSDictionary dictionaryWithContentsOfFile:thePath] retain];
	
	statisticsCollector = [[SchellingStatistics alloc] initWithGame:game];
	
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

@end
