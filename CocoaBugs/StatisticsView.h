//
//  StatisticsView.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class StatisticsData;

@interface StatisticsView: NSView {
	NSString *title;
	StatisticsData *stats;
}

@property(readwrite, copy) NSString *title;
@property(readwrite, retain) StatisticsData *stats;

@end
