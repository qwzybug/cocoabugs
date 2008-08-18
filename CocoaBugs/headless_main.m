//
//  headless_main.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"
#import "ALifePluginLoader.h"
#import "StatisticsController.h"
#import "ALifeRunExporter.h"
#import "ALifeSimulationController.h"

StatisticsController *statisticsController;

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSArray *plugins = [ALifePluginLoader allPlugIns];
	NSString *configurationFile = [args stringForKey:@"f"];
	NSString *outputDirectory = [args stringForKey:@"o"];
	int numberOfSteps = [args integerForKey:@"s"];
	
	if (!(configurationFile && outputDirectory && numberOfSteps)) {
		printf("Usage: HeadlessBugs -f <config filename> -o <output directory path> -s <number of steps>\n");
		return 1;
	}
	
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:configurationFile];
	
	NSString *identifier = [data objectForKey:@"identifier"];
	NSDictionary *configuration = [data objectForKey:@"configuration"];
	
	Class <ALifeController> selectedPlugin;
	for (Class <ALifeController> plugin in plugins) {
		if ([[plugin name] isEqual:identifier]) {
			selectedPlugin = plugin;
			break;
		}
	}
	
	if (!selectedPlugin) {
		printf("Plugin class not found. Make sure it's installed.");
		return 1;
	}
	
	ALifeSimulationController *simulationController = [[ALifeSimulationController alloc] initWithSimulationClass:selectedPlugin configuration:configuration];
	
	statisticsController = [[StatisticsController alloc] init];
	statisticsController.statisticsSize = numberOfSteps;
	[statisticsController setSource:[simulationController.lifeController statisticsCollector]
					  forStatistics:[[simulationController.lifeController properties] objectForKey:@"statistics"]];
	
	int step;
	for (step = 0; step < numberOfSteps; step++) {
		printf("Step %d\n", step);
		[simulationController.lifeController update];
	}
	
	[ALifeRunExporter exportSimulation:simulationController withStatistics:statisticsController toDirectory:outputDirectory];
	
	printf("Done.\n");
	
	[pool release];
	return 0;
}
