//
//  headless_main.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Bugs/Bugs.h>
#import <Foundation/NSObjCRuntime.h>

#import "ALifePluginLoader.h"
#import "StatisticsController.h"
#import "ALifeRunExporter.h"
#import "ALifeSimulationController.h"

static NSArray *plugins;

typedef enum {
	kBugsCommandRun,
	kBugsCommandPlugins
} BugsCommand;

void printHelpAndDie()
{
	NSMutableArray *usageStrings = [NSMutableArray array];
	
	[usageStrings addObject:@"Usage: cocoabugs <command> <options>"];
	[usageStrings addObject:@"Commands: run, plugins"];
	
	NSString *usageString = [usageStrings componentsJoinedByString:@"\n"];
	printf("%s\n", [usageString cStringUsingEncoding:NSASCIIStringEncoding]);
	
	exit(0);
}

void printUsageAndDie(BugsCommand command) {
	switch (command) {
		case kBugsCommandRun:
			printf("Usage: cocoabugs run <config filename>\n");
			printf("                     --output <output directory path>\n");
			printf("                     --steps <number of steps>\n");
			printf("                     [--runs <number of runs>]\n");
			printf("                     [--sample <shuffle key>\n");
			printf("                        [--min <minimum value]\n");
			printf("                        [--max <maximum value] ]\n");
			break;
		default:
			break;
	}
	
	exit(1);
}

void printPluginsAndDie()
{
	NSSortDescriptor *titleSort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	printf("\nInstalled plugins:\n");
	NSArray *configuration;
//	NSArray *statistics;
	for (Class <ALifeController> plugin in plugins) {
		printf("\n%s\n\n", [[plugin name] cStringUsingEncoding:NSASCIIStringEncoding]);
		// print configuration options
		configuration = [[plugin configurationOptions] sortedArrayUsingDescriptors:[NSArray arrayWithObject:titleSort]];
		printf(" Options:\n");
		for (NSDictionary *option in configuration) {
			if ([[option valueForKey:@"type"] isEqual:@"Bitmap"])
				continue;
			
			printf(" - %s\n   Key: %s, range: ", [[option valueForKey:@"title"] cStringUsingEncoding:NSASCIIStringEncoding],
									 [[option valueForKey:@"name"] cStringUsingEncoding:NSASCIIStringEncoding]);
			
			if ([[option valueForKey:@"type"] isEqual:@"Float"]) {
				printf("[%.1f, %.1f]\n", [[option valueForKey:@"minValue"] floatValue], [[option valueForKey:@"maxValue"] floatValue]);
			}
			
			else if ([[option valueForKey:@"type"] isEqual:@"Integer"]) {
				printf("[%d, %d]\n", [[option valueForKey:@"minValue"] intValue], [[option valueForKey:@"maxValue"] intValue]);
			}
		}
		printf("\n");
		
	}
	printf("\n");
}

void runSimulations(NSString *configurationFile,
					NSString *outputDirectory,
					int numberOfSteps,
					int numberOfRuns,
					NSString *shuffleKey,
					NSNumber *shuffleMin,
					NSNumber *shuffleMax)
{
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
	
	if (!selectedPlugin || ![selectedPlugin conformsToProtocol:@protocol(ALifeController)]) {
		printf("Plugin class '%s' not found. Make sure it's installed.\n", [identifier cStringUsingEncoding:NSASCIIStringEncoding]);
		exit(1);
	}
	
	// check if directory exists
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:outputDirectory])
		[fileManager createDirectoryAtPath:outputDirectory attributes:NULL];	
	
	int step;
	int run;
	int runFrac = (int)(numberOfSteps / 10.0);
	ALifeSimulationController *simulationController;
	StatisticsController *statisticsController;
	NSDictionary *samplingOptions;
	
	for (run = 0; run < numberOfRuns; run++) {
		printf("Run %d", run + 1);
	BAIL:
		;
		NSAutoreleasePool *runPool = [[NSAutoreleasePool alloc] init];
		
		samplingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
						   shuffleKey, @"key",
						   shuffleMin, @"minValue",
						   shuffleMax, @"maxValue",
						   nil];
		simulationController = [ALifeSimulationController controllerWithSimulationClass:selectedPlugin
																		  configuration:configuration
																			   sampling:samplingOptions];
		if (!simulationController) {
			exit(1);
		}
		
		statisticsController = [[[StatisticsController alloc] init] autorelease];
		int samplingFrequency = 10;
		statisticsController.statisticsSize = numberOfSteps / samplingFrequency;
		// TODO: kludge! ugly horrible kludge!
		statisticsController.samplingFrequency = samplingFrequency;
		[statisticsController setSource:[simulationController.lifeController statisticsCollector]
						  forStatistics:[[simulationController.lifeController properties] objectForKey:@"statistics"]];
		
		// activity statistics
		[simulationController.lifeController setCollectActivity:YES];
		
		fflush(stdout);
		for (step = 0; step < numberOfSteps; step++) {
			if (!simulationController.lifeController.alive) {
				printf("x");
				fflush(stdout);
				[runPool release];
				goto BAIL;
			}
			if (step % runFrac == 1) {
				printf(".");
				fflush(stdout);
			}
			[simulationController.lifeController update];
		}
		NSString *dir = [NSString stringWithFormat:@"%@/%d", outputDirectory, run + 1];
		[ALifeRunExporter exportSimulation:simulationController withStatistics:statisticsController toDirectory:dir];
		
		[runPool release];

		printf("\n");
	}
	
	printf("Done.\n");
}

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	if (argc < 2) {
		printHelpAndDie();
	}
	
	plugins = [ALifePluginLoader allPlugIns];
	
	NSString *command = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
	
	if ([command isEqual:@"run"]) {
		if (argc < 3) {
			printUsageAndDie(kBugsCommandRun);
		}
		NSString *configurationFile = [NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding];
		NSString *outputDirectory = [args stringForKey:@"-output"];
		int numberOfSteps = [args integerForKey:@"-steps"];
		int numberOfRuns  = [args integerForKey:@"-runs"];
		numberOfRuns = numberOfRuns ? numberOfRuns : 1;
		
		if (!(configurationFile && outputDirectory && numberOfSteps)) {
			printUsageAndDie(kBugsCommandRun);
		}
		
		NSString *sampleKey = [args stringForKey:@"-sample"];
		
		NSNumber *minValue = [NSNumber numberWithFloat:[args floatForKey:@"-min"]];
		NSNumber *maxValue = [NSNumber numberWithFloat:[args floatForKey:@"-max"]];
		
		runSimulations(configurationFile, outputDirectory, numberOfSteps, numberOfRuns, sampleKey, minValue, maxValue);
	}
	else if ([command isEqual:@"plugins"]) {
		printPluginsAndDie();
	}
	else {
		printHelpAndDie();
	}
	
	[pool release];
	return 0;
}
