//
//  ALifeShuffler.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeShuffler.h"

static NSDictionary *gShuffleTable = NULL;

@interface IntegerShuffler : NSObject <ALifeValueShuffler> @end
@interface FloatShuffler : NSObject <ALifeValueShuffler> @end

#pragma mark -

@implementation ALifeShuffler

+ (NSDictionary *)shuffleTable;
{
	if (!gShuffleTable) {
		gShuffleTable = [[NSMutableDictionary dictionary] retain];
		[gShuffleTable setValue:[[[IntegerShuffler alloc] init] autorelease] forKey:@"Integer"];
		[gShuffleTable setValue:[[[FloatShuffler alloc] init] autorelease] forKey:@"Float"];
	}
	return gShuffleTable;
}

+ (id)shuffleType:(NSString *)type withOptions:(NSDictionary *)options;
{
	id <ALifeValueShuffler> shuffler = [[self shuffleTable] objectForKey:type];
	if (shuffler)
		return [shuffler shuffle:options];
	return [NSNull null];
}

+ (id)shuffleType:(NSString *)type min:(NSNumber *)min max:(NSNumber *)max;
{
	id <ALifeValueShuffler> shuffler = [[self shuffleTable] objectForKey:type];
	if (shuffler)
		return [shuffler shuffleWithMin:min max:max];
	return [NSNull null];
}

@end

@implementation IntegerShuffler
- (id)shuffle:(NSDictionary *)options;
{
	int p = [[options valueForKey:@"principalValue"] intValue];
	int d = [[options valueForKey:@"delta"] intValue];
	
	int v = p + (random() % (2 * d + 1)) - d;
	
	return [NSNumber numberWithInt:v];
}
- (id)shuffleWithMin:(NSNumber *)min max:(NSNumber *)max;
{
	int minValue = [min intValue];
	int maxValue = [max intValue];
	
	int v = (random() % (maxValue - minValue)) + minValue;
	
	return [NSNumber numberWithInt:v];
}
@end

@implementation FloatShuffler
- (id)shuffle:(NSDictionary *)options;
{
	float p = [[options valueForKey:@"principalValue"] floatValue];
	float d = [[options valueForKey:@"delta"] floatValue];
	
	int max = INT_MAX;
	float v = p + 2 * ((float)random() / (float)(max)) - d;
	
	return [NSNumber numberWithFloat:v];
}
- (id)shuffleWithMin:(NSNumber *)min max:(NSNumber *)max;
{
	float minValue = [min floatValue];
	float maxValue = [max floatValue];
	
	float v = ((float)random() / INT_MAX) * (maxValue - minValue) + minValue;
	
	return [NSNumber numberWithFloat:v];
}
@end