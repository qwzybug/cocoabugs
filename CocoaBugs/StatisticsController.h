//
//  StatisticsController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StatisticsView, StatisticsTableView;

@interface StatisticsController : NSObject {
	id source;
	NSMutableDictionary *stats;
	IBOutlet NSPanel *statisticsPanel;
	NSMutableArray *statisticsViews;
	int statisticsSize;
	int samplingFrequency;
}

@property (readwrite, strong) id source;
@property (readwrite, strong) NSMutableArray *statisticsViews;
@property (readwrite, assign) int statisticsSize;
@property (readwrite, strong) NSMutableDictionary *stats;
@property (nonatomic, assign) int samplingFrequency;

- (void)setSource:(id)statisticsCollector forStatistics:(NSDictionary *)descriptions;
- (void)registerForPath:(NSString *)path name:(NSString *)name;

@end
