//
//  ALifeRunExporter.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifeRunExporter.h"

#import "StatisticsController.h"
#import "StatisticsView.h"


@implementation ALifeRunExporter

+ (void)exportSimulation:(id <ALifeController>)simulation withStatistics:(StatisticsController *)statisticsController toFilePath:(NSString *)path;
{
	NSPrintInfo *info = [NSPrintInfo sharedPrintInfo];
	NSRect pageSize = [info imageablePageBounds];
	NSRect printingBounds = NSMakeRect([info leftMargin], [info bottomMargin], pageSize.size.width - 2 * [info leftMargin], pageSize.size.height - 2 * [info bottomMargin]);
	NSView *printView = [[NSView alloc] initWithFrame:printingBounds];
	
	float height = printView.frame.size.height;
	float statsHeight = MIN(height / [statisticsController.statisticsViews count], 100.0);
	
	printingBounds.size.height = MIN(statsHeight * [statisticsController.statisticsViews count], printingBounds.size.height);
	printView.frame = printingBounds;
	
	int i;
	for (i = 0; i < [statisticsController.statisticsViews count]; i++) {
		NSRect frame = NSMakeRect(0, i * statsHeight, printView.frame.size.width, statsHeight);
		StatisticsView *view = [statisticsController.statisticsViews objectAtIndex:i];
		view.frame = frame;
		[printView addSubview:view];
	}
	
	NSData *printData = [printView dataWithPDFInsideRect:printingBounds];
	[printData writeToFile:path atomically:NO];
	
	[printView release];
}

@end
