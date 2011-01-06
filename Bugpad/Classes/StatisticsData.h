//
//  StatisticsData.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALifeSimulation.h"

@class PixelImage;

@interface StatisticsData : NSObject {
	NSMutableArray *data;
	NSMutableArray *maxes;
	int cursor;
	int size;
	int samplingFrequency;
	int tick;
	BOOL singular;
	
	ALifeSimulation *simulation;
	NSString *keyPath;
	
	PixelImage *bitmap;
	
	NSMutableDictionary *currentAccumulatedData;
}

@property (nonatomic, retain) ALifeSimulation *simulation;
@property (nonatomic, retain) NSString *keyPath;

@property (nonatomic, readonly) NSMutableArray *data;

@property (readonly) int size;
@property (readonly) int samplingFrequency;
@property (readwrite) int cursor;
@property (readwrite) BOOL singular;
@property (nonatomic, readonly) NSString *csv;

@property (nonatomic, retain) NSMutableDictionary *currentAccumulatedData;

@property (nonatomic, retain) PixelImage *bitmap;

- (id)initWithSimulation:(ALifeSimulation *)simulation keyPath:(NSString *)keyPath capacity:(int)capacity samplingFrequency:(int)frequency;
- (void)addDataPoint:(int)datum;
- (int)getDataPoint:(int)num;

- (int)maxValue;
- (void)addDataSet:(NSSet *)dataSet;
- (NSSet *)getDataSet:(int)num;

- (void)accumulateDataSet:(NSDictionary *)dataSet;

@end
