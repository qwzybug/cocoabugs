//
//  StatisticsController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsController.h"
#import "StatisticsData.h"
#import "StatisticsView.h"
#import "StatisticsTableView.h"

@implementation StatisticsController

@synthesize source, statisticsPanel, statisticsViews, statisticsSize, stats;
@synthesize samplingFrequency;

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	self.stats = [NSMutableDictionary dictionaryWithCapacity:5];
	self.statisticsViews = [NSMutableArray arrayWithCapacity:5];
	
	// BIG TODO: make this do something!
	self.samplingFrequency = 10;
	
	return self;
}

- (void)dealloc;
{
	for (NSString *key in stats) {
		[source removeObserver:self forKeyPath:key];
	}
	
	
}

- (void)setSource:(id)statisticsCollector forStatistics:(NSDictionary *)descriptions;
{
	self.source = statisticsCollector;
	if (!statisticsSize) statisticsSize = 500;
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
	for (NSDictionary *description in [[descriptions allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]) {
		[self registerForPath:[description objectForKey:@"keyPath"]
						 name:[description objectForKey:@"title"]];
	}
}

- (void)registerForStatistics:(NSDictionary *)description;
{
	
}

- (void)registerForPath:(NSString *)path name:(NSString *)name;
{
#define STATS_WIDTH 350
#define STATS_HEIGHT 80
	// create stats object
	StatisticsData *data = [[StatisticsData alloc] initWithCapacity:statisticsSize samplingFrequency:self.samplingFrequency];
	[stats setObject:data forKey:path];
	
	// observe requested key path
	[source addObserver:self
			 forKeyPath:path
				options:NSKeyValueObservingOptionNew
				context:NULL];
	
	// add stats view to window if we have a panel
	if (statisticsPanel) {
		// calculate statistics frame
		NSRect frame = NSMakeRect(0, 80 * ([stats count] - 1), STATS_WIDTH, STATS_HEIGHT);
		// create stats view
		StatisticsView *view = [[StatisticsView alloc] initWithFrame:frame];
		[view setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
		
		NSRect statsFrame = statisticsPanel.frame;
		[[statisticsPanel contentView] addSubview:view];
		[statisticsPanel setFrame:NSMakeRect(statsFrame.origin.x, statsFrame.origin.y - STATS_HEIGHT, statsFrame.size.width, statsFrame.size.height + STATS_HEIGHT) display:YES];
		
		[statisticsPanel setContentMaxSize:NSMakeSize(500, [[statisticsPanel contentView] frame].size.height)];
		[statisticsPanel setContentMinSize:NSMakeSize(100, [[statisticsPanel contentView] frame].size.height)];
		
		[self.statisticsViews addObject:view];
		
		// put 'em together
		view.stats = data;
		view.title = name;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	for (NSString *key in stats) {
		if ([keyPath isEqual:key]) {
			[[stats objectForKey:keyPath] addDataSet:[change objectForKey:NSKeyValueChangeNewKey]];
		}
	}
}

@end
