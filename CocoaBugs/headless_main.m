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

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSArray *plugins = [ALifePluginLoader allPlugIns];
	NSString *configurationFile = [args stringForKey:@"f"];
	NSString *outputDirectory = [args stringForKey:@"o"];
	int numberOfSteps = [args integerForKey:@"s"];
	int numberOfRuns  = [args integerForKey:@"n"];
	numberOfRuns = numberOfRuns ? numberOfRuns : 1;
	
	if (!(configurationFile && outputDirectory && numberOfSteps)) {
		printf("Usage: HeadlessBugs -f <config filename> -o <output directory path> -s <number of steps> [-n <number of runs>]\n");
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
	
	int step;
	int run;
	int runFrac = (int)(numberOfSteps / 10.0);
	ALifeSimulationController *simulationController;
	StatisticsController *statisticsController;
	
	for (run = 0; run < numberOfRuns; run++) {
		simulationController = [[ALifeSimulationController alloc] initWithSimulationClass:selectedPlugin configuration:configuration];
		
		statisticsController = [[StatisticsController alloc] init];
		statisticsController.statisticsSize = numberOfSteps;
		[statisticsController setSource:[simulationController.lifeController statisticsCollector]
						  forStatistics:[[simulationController.lifeController properties] objectForKey:@"statistics"]];
		
		printf("Run %d", run + 1);
		fflush(stdout);
		for (step = 0; step < numberOfSteps; step++) {
			if (step % runFrac == 0) {
				printf(".");
				fflush(stdout);
			}
			[simulationController.lifeController update];
		}
		NSString *dir = [NSString stringWithFormat:@"%@/%d", outputDirectory, run + 1];
		[ALifeRunExporter exportSimulation:simulationController withStatistics:statisticsController toDirectory:dir];
		
		[statisticsController release];
		[simulationController release];
		
		printf("\n");
	}
	
	printf("Done.\n");
	
	[pool release];
	return 0;
}
