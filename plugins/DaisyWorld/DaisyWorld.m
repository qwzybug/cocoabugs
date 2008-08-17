//
//  LifeModel.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DaisyWorld.h"

#import "DaisyCell.h"
#import "Daisy.h"

#define BARE_ALBEDO 0.5
#define WHITE_ALBEDO 0.75
#define BLACK_ALBEDO 0.25

@implementation DaisyWorld

@synthesize step, terrain, sunLuminance, sunLuminanceDelta;

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	size = 50;
	
	int i, j;
	
	terrain = [[NSMutableArray arrayWithCapacity:size] retain];
	
	for (i = 0; i < size; i++) {
		NSMutableArray *row = [NSMutableArray arrayWithCapacity:size];
		for (j = 0; j < size; j++) {
			[row addObject:[[[DaisyCell alloc] init] autorelease]];
		}
		[terrain addObject:row];
	}
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing LifeModel");
	
	self.terrain = nil;
	
	[super dealloc];
}

- (void)update;
{
	float uncoveredPortion;
	float blackPortion;
	float whitePortion;
	
	int whiteCount;
	int blackCount;
	
	for (NSMutableArray *row in terrain) {
		for (DaisyCell *daisyCell in terrain) {
			if (daisyCell.daisy) {
				if (daisyCell.daisy.type == WHITE_DAISY) {
					whiteCount++;
				} else {
					blackCount++;
				}
			}
		}
	}
	
	int area = size * size;
	
	blackPortion = (float)blackCount / area;
	whitePortion = (float)whiteCount / area;
	uncoveredPortion = (1.0 - blackPortion - whitePortion);
	
	float planetaryAlbedo = blackPortion * BLACK_ALBEDO + whitePortion * WHITE_ALBEDO + uncoveredPortion * BARE_ALBEDO;
	
	self.step++;
	NSLog(@"%d", step);
}

@end
