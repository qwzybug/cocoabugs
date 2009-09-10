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
#import "ALifeController.h"
#import "StatisticsTableView.h"

@implementation StatisticsController

@synthesize source, statisticsViews, statisticsSize, stats;

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	self.stats = [NSMutableDictionary dictionaryWithCapacity:5];
	self.statisticsViews = [NSMutableArray arrayWithCapacity:5];
	
	return self;
}

- (void)dealloc;
{
	for (NSString *key in stats) {
		[source removeObserver:self forKeyPath:key];
	}
	[stats release];
	[source release];
	
	[statisticsViews release];
	
	[super dealloc];
}

- (void)setSource:(id)statisticsCollector forStatistics:(NSDictionary *)descriptions;
{
	self.source = statisticsCollector;
	if (!statisticsSize) statisticsSize = 1000;
	
	for (NSDictionary *description in [descriptions allValues]) {
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
	StatisticsData *data = [[[StatisticsData alloc] initWithCapacity:statisticsSize] autorelease];
	[stats setObject:data forKey:path];
	
	// observe requested key path
	[source addObserver:self
			 forKeyPath:path
				options:NSKeyValueObservingOptionNew
				context:NULL];
	
	// add stats view to window if we have a panel
	if (statisticsPanel) {
		// calculate statistics frame
		NSRect frame = NSMakeRect(0, 80 * [stats count], STATS_WIDTH, STATS_HEIGHT);
		// create stats view
		StatisticsView *view = [[[StatisticsView alloc] initWithFrame:frame] autorelease];
		[view setAutoresizingMask:(NSViewWidthSizable)];
		
		NSRect statsFrame = statisticsPanel.frame;
		[statisticsPanel setFrame:NSMakeRect(statsFrame.origin.x, statsFrame.origin.y - STATS_HEIGHT, statsFrame.size.width, statsFrame.size.height + STATS_HEIGHT) display:YES];
		[self addStatisticsView:view toView:[statisticsPanel contentView]];
		
		[self.statisticsViews addObject:view];
		
		// put 'em together
		view.stats = data;
		view.title = name;
	}
}

- (void)addStatisticsView:(StatisticsView *)statsView toView:(NSView *)parentView;
{
	// add stats view to window
	[parentView addSubview:statsView];
	// resize window to fit
	NSRect frame = [parentView frame];
	[parentView setFrame:NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 80.0)];
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
