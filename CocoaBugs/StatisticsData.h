//
//  StatisticsData.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StatisticsData : NSObject {
	NSMutableArray *data;
	NSMutableArray *maxes;
	int cursor;
	int size;
	bool multiway;
}

@property (readonly) int size;
@property (readwrite) int cursor;
@property (readwrite) bool multiway;
@property (nonatomic, readonly) NSString *csv;

- (id)initWithCapacity:(int)capacity;
- (void)addDataPoint:(int)datum;
- (int)getDataPoint:(int)num;

- (int)maxValue;
- (void)addDataSet:(NSSet *)dataSet;
- (NSSet *)getDataSet:(int)num;

@end
