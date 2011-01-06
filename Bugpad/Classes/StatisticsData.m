//
//  StatisticsData.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsData.h"

#import "PixelImage.h"

@implementation StatisticsData

@synthesize size, cursor, singular, samplingFrequency;
@synthesize simulation;
@synthesize keyPath;
@synthesize data;
@synthesize bitmap;
@dynamic csv;

@synthesize currentAccumulatedData;

- (void)dealloc;
{
	[simulation removeObserver:self forKeyPath:keyPath];
	[simulation release], simulation = nil;
	[keyPath release], keyPath = nil;
	
	[data release]; data = nil;
	[maxes release]; maxes = nil;
	[bitmap release], bitmap = nil;
	
	[super dealloc];
}

- (id)initWithSimulation:(ALifeSimulation *)theSimulation keyPath:(NSString *)theKeyPath capacity:(int)capacity samplingFrequency:(int)frequency;
{
	if (!(self = [super init]))
		return nil;
	
	size = capacity;
	samplingFrequency = frequency;
	tick = -1;
	
	data = [[NSMutableArray arrayWithCapacity:size] retain];
	maxes = [[NSMutableArray arrayWithCapacity:size] retain];
	
	self.simulation = theSimulation;
	self.keyPath = theKeyPath;
	
	[self.simulation addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
	
	int i;
	for (i = 0; i < size; i++) {
		[data addObject:[NSNumber numberWithInt:0]];
		[maxes addObject:[NSNumber numberWithInt:0]];
	}
	
	currentAccumulatedData = [[NSMutableDictionary dictionary] retain];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)theKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	if ([theKeyPath isEqual:self.keyPath]) {
		id newValue = [change valueForKey:NSKeyValueChangeNewKey];
		
		if ([newValue isKindOfClass:[NSNumber class]]) {
			[self addDataPoint:[newValue intValue]];
		}
		else if ([newValue isKindOfClass:[NSDictionary class]]) {
			[self accumulateDataSet:newValue];
		}
	}
}

- (void)addDataPoint:(int)datum;
{
	tick++;
	if (tick % samplingFrequency != 0)
		return;
	
	self.cursor = (cursor + 1) % size;
	
	[data replaceObjectAtIndex:cursor withObject:[NSNumber numberWithInt:datum]];
	
	float dy = (float)self.bitmap.height / [self maxValue];
	float dx = (float)self.bitmap.width / self.size;
	
	[bitmap setColor:[UIColor blackColor] atX:floor(dx * cursor) y:floor(dy * datum)];
}

- (int)getDataPoint:(int)num;
{
	return [[data objectAtIndex:(cursor + num) % size] intValue];
}
		 
- (int)maxValue;
{
	int max = 1;
	if (!self.singular) {
		return 1000;
	}
	
	for (NSNumber *num in data) {
		max = MAX([num intValue], max);
	}
	
	return max;
//	for (NSNumber *num in maxes) {
//		cur = [num intValue];
//		max = max > cur ? max : cur;
//	}
	
//	for (id value in data) {
//		if ([value isKindOfClass:[NSDictionary class]]) {
//			for (NSNumber *num in [value allValues]) {
//				max = MAX(max, [num intValue]);
//			}
//		}
//		else {
//			max = MAX(max, [value intValue]);
//		}
//	}
//	return max;
}

- (void)addDataSet:(NSSet *)dataSet;
{
	int max = 0, cur;
	for (NSNumber *num in dataSet) {
		cur = [num intValue];
		max = max > cur ? max : cur;
	}
	[maxes replaceObjectAtIndex:cursor withObject:[NSNumber numberWithInt:max]];
	
	self.cursor = (cursor + 1) % size;

	float dy = (float)self.bitmap.height / [self maxValue];
	float dx = (float)self.bitmap.width / self.size;
	
	for (NSNumber *number in dataSet) {
		int datum = [number intValue];
		[bitmap setColor:[UIColor blackColor] atX:floor(dx * cursor) y:floor(dy * datum)];
	}
}

- (void)accumulateDataSet:(NSDictionary *)dataSet;
{
	self.cursor = (cursor + 1) % size;
	
	float dy = (float)self.bitmap.height / [self maxValue];
	float dx = (float)self.bitmap.width / self.size;
	
	for (NSNumber *key in [dataSet allKeys]) {
		NSNumber *value = nil;
		if (value = [self.currentAccumulatedData objectForKey:key]) {
			value = [NSNumber numberWithInt:([value intValue] + [[dataSet objectForKey:key] intValue])];
		}
		else {
			value = [dataSet objectForKey:key];
		}
		[self.currentAccumulatedData setObject:value forKey:key];
		[bitmap setColor:[UIColor blackColor] atX:(dx * cursor) y:(dy * [value intValue])];
	}
	
	[data replaceObjectAtIndex:cursor withObject:[self.currentAccumulatedData copy]];
	
//	int i = 0;
//	for (NSDictionary *datums in data) {
//		i++;
//		if ([datums isKindOfClass:[NSNumber class]]) {
//			continue;
//		}
//		
//		for (NSNumber *value in [datums allValues]) {
//		}
//	}
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
