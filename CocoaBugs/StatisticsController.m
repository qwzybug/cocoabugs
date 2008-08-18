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

@synthesize source, statisticsViews, statisticsSize;

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	stats = [[NSMutableDictionary dictionaryWithCapacity:5] retain];
	statisticsViews = [[NSMutableArray arrayWithCapacity:5] retain];
	
	return self;
}

- (void)dealloc;
{
	for (NSString *key in stats) {
		[source removeObserver:self forKeyPath:key];
	}
	[stats release];
	self.source = nil;
	
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
	// calculate statistics frame
	NSRect frame = NSMakeRect(0, 80 * [stats count], STATS_WIDTH, STATS_HEIGHT);
	// create stats view
	StatisticsView *view = [[[StatisticsView alloc] initWithFrame:frame] autorelease];
	[view setAutoresizingMask:(NSViewWidthSizable)];
	// add stats view to window
//	[[statisticsPanel contentView] addSubview:view];
	// resize window to fit
//	frame = [statisticsPanel frame];
//	[statisticsPanel setFrame:NSMakeRect(frame.origin.x, frame.origin.y - 80.0, frame.size.width, frame.size.height + 80.0) display:YES];
//	[statisticsTableView.statisticsViews addObject:view];
//	[statisticsCells addObject:view];
	if (statisticsPanel) {
		NSRect frame = statisticsPanel.frame;
		[statisticsPanel setFrame:NSMakeRect(frame.origin.x, frame.origin.y - 80.0, frame.size.width, frame.size.height + 80.0) display:YES];
		[self addStatisticsView:view toView:[statisticsPanel contentView]];
	}
	[self.statisticsViews addObject:view];
	
	// create stats object
	StatisticsData *data = [[[StatisticsData alloc] initWithCapacity:statisticsSize] autorelease];
	
	// put 'em together
	view.stats = data;
	view.title = name;
	[stats setObject:data forKey:path];
	
	// observe requested key path
	[source addObserver:self
			 forKeyPath:path
				options:NSKeyValueObservingOptionNew
				context:NULL];
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
