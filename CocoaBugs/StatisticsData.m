//
//  StatisticsData.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsData.h"

@implementation StatisticsData

@synthesize size, cursor, multiway, samplingFrequency;
@dynamic csv;

- (id)initWithCapacity:(int)capacity samplingFrequency:(int)frequency;
{
	if (!(self = [super init]))
		return nil;
	
	size = capacity;
	samplingFrequency = frequency;
	tick = -1;
	
	data = [[NSMutableArray arrayWithCapacity:size] retain];
	maxes = [[NSMutableArray arrayWithCapacity:size] retain];
	
	int i;
	for (i = 0; i < size; i++) {
		[data addObject:[NSSet set]];
		[maxes addObject:[NSNumber numberWithInt:0]];
	}
	
	return self;
}

- (void)dealloc;
{
	[data release]; data = nil;
	[maxes release]; maxes = nil;
	
	[super dealloc];
}

- (void)addDataPoint:(int)datum;
{
	[data replaceObjectAtIndex:cursor withObject:[NSNumber numberWithInt:datum]];
	self.cursor = (cursor + 1) % size;
}

- (int)getDataPoint:(int)num;
{
	return [[data objectAtIndex:(cursor + num) % size] intValue];
}
		 
- (int)maxValue;
{
	int max = 1, cur;
	for (NSNumber *num in maxes) {
		cur = [num intValue];
		max = max > cur ? max : cur;
	}
	return max;
}

- (void)addDataSet:(NSSet *)dataSet;
{
	tick++;
	if (tick % samplingFrequency != 0)
		return;
	
	[data replaceObjectAtIndex:cursor withObject:dataSet];
	
	int max = 0, cur;
	for (NSNumber *num in dataSet) {
		cur = [num intValue];
		max = max > cur ? max : cur;
	}
	[maxes replaceObjectAtIndex:cursor withObject:[NSNumber numberWithInt:max]];
	
	self.cursor = (cursor + 1) % size;
}

- (void)accumulateDataSet:(NSSet *)set;
{
	
}

- (NSSet *)getDataSet:(int)num;
{
	return [data objectAtIndex:(cursor + num) % size];
}

- (NSString *)csv;
{
	NSMutableArray *lines = [NSMutableArray arrayWithCapacity:(data.count + 1)];
	[lines addObject:@"step,value"];
	int i = 0;
	for (NSSet *dataPoints in data) {
		[lines addObject:[NSString stringWithFormat:@"%d,%@", i * samplingFrequency, [[dataPoints allObjects] componentsJoinedByString:@","]]];
		i++;
	}
	return [lines componentsJoinedByString:@"\n"];
}

@end
