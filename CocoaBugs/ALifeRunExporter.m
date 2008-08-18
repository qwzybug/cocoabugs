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
#import "ALifeSimulationController.h"


@implementation ALifeRunExporter

+ (void)exportSimulation:(ALifeSimulationController *)simulationController withStatistics:(StatisticsController *)statisticsController toDirectory:(NSString *)path;
{
	// check if directory exists
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path])
		[fileManager createDirectoryAtPath:path attributes:NULL];
	
	// export statistics to .pdf
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
	[printData writeToFile:[NSString stringWithFormat:@"%@/statistics.pdf", path] atomically:NO];
	[printView release];
	
	// export configuration to .cocoabugs file
	// TODO: DRY this up (repeated in ALifeConfigurationWindowController)
	NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[[simulationController.lifeController class] name], @"identifier", simulationController.configuration, @"configuration", nil];
	[data writeToFile:[NSString stringWithFormat:@"%@/simulation.cocoabugs", path] atomically:NO];
}

@end
