//
//  StatisticsTableView.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface StatisticsTableView : NSTableView {
	NSMutableArray *statisticsViews;
}

@property (readwrite, retain) NSMutableArray *statisticsViews;

@end
