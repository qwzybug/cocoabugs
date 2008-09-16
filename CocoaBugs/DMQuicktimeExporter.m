//
//  DMQuicktimeExporter.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DMQuicktimeExporter.h"


@implementation DMQuicktimeExporter

@synthesize view;

+ (id)movieExporterForView:(NSView *)theView;
{
	return [[[self alloc] initWithView:theView] autorelease];
}

- (id)initWithView:(NSView *)theView;
{
	if (!(self = [super init]))
		return nil;
	
	self.view = theView;
	
	// load the exporter nib
	[NSBundle loadNibNamed:@"DMQuicktimeExporter" owner:self];
	
	// initialize a blank movie
	NSString *tempName = [NSString stringWithCString:tmpnam(nil) 
											encoding:[NSString defaultCStringEncoding]];
	mMovie = [[QTMovie alloc] initToWritableFile:tempName error:nil];
	[mMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
	[mMovie setDelegate:self];
	
	int index = selectedComponentIndex = 0;
	for (NSDictionary *component in [self availableComponents]) {
		if ([[component objectForKey:@"name"] isEqual:@"MPEG-4"]) {
			selectedComponentIndex = index;
			break;
		}
		index++;
	}
	
	return self;
}

- (void)addFrame;
{
	NSImage *image;
	NSDictionary *imageAttributes = [NSDictionary dictionaryWithObjectsAndKeys:@"png ", QTAddImageCodecType, nil];
	image = [[NSImage alloc] initWithData:[view dataWithPDFInsideRect:[view visibleRect]]];
	[mMovie addImage:image
		 forDuration:QTMakeTime(1, 30)
	  withAttributes:imageAttributes];
	[image release];	
}

- (void)exportMovie:(NSString *)filePath;
{
	NSData *exportSettings = [self getExportSettings];
	if (exportSettings) {
		NSDictionary *selectedComponent = [[self availableComponents] objectAtIndex:selectedComponentIndex];
		[self writeMovie:mMovie toFile:filePath withComponent:selectedComponent withExportSettings:exportSettings];
	}
}

- (void)dealloc;
{
	self.view = nil;
	[mMovie release];
	[super dealloc];
}

#pragma mark Ganked from cocoadev.com

- (NSArray *)availableComponents
{
	NSMutableArray *array = [NSMutableArray array];
	
	ComponentDescription cd;
	Component c = NULL;
	
	cd.componentType = MovieExportType;
	cd.componentSubType = 0;
	cd.componentManufacturer = 0;
	cd.componentFlags = canMovieExportFiles;
	cd.componentFlagsMask = canMovieExportFiles;
	
	while((c = FindNextComponent(c, &cd)))
	{
		Handle name = NewHandle(4);
		ComponentDescription exportCD;
		
		if (GetComponentInfo(c, &exportCD, name, nil, nil) == noErr)
		{
			char *namePStr = *name;
			NSString *nameStr = [[NSString alloc] initWithBytes:&namePStr[1] length:namePStr[0] encoding:NSUTF8StringEncoding];
			
			NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
										nameStr, @"name",
										[NSData dataWithBytes:&c length:sizeof(c)], @"component",
										[NSNumber numberWithLong:exportCD.componentType], @"type",
										[NSNumber numberWithLong:exportCD.componentSubType], @"subtype",
										[NSNumber numberWithLong:exportCD.componentManufacturer], @"manufacturer",
										nil];
			[array addObject:dictionary];
			[nameStr release];
		}
		
		DisposeHandle(name);
	}
	return array;
}

- (NSData *)getExportSettings;
{
	Component c;
	memcpy(&c, [[[[self availableComponents] objectAtIndex:selectedComponentIndex] objectForKey:@"component"] bytes], sizeof(c));
	
	MovieExportComponent exporter = OpenComponent(c);
	Boolean canceled;
	QTAtomContainer settings;
	
	// get last settings from user defaults
	NSData *lastSettings = [[NSUserDefaults standardUserDefaults] objectForKey:@"movieExportSettings"];
	if (lastSettings) {
		const void *bytes = [lastSettings bytes];
		MovieExportSetSettingsFromAtomContainer(exporter, (QTAtomContainer)&bytes);
	}
	
	Movie myMovie = [mMovie quickTimeMovie];
	ComponentResult err = MovieExportDoUserDialog(exporter, myMovie, NULL, 0, GetMovieDuration(myMovie), &canceled);
	if(err)
	{
		NSLog(@"Got error %d when calling MovieExportDoUserDialog",err);
		CloseComponent(exporter);
		return nil;
	}
	if(canceled)
	{
		NSLog(@"Canceled movie save.");
		CloseComponent(exporter);
		return nil;
	}
	err = MovieExportGetSettingsAsAtomContainer(exporter, &settings);
	if(err)
	{
		NSLog(@"Got error %d when calling MovieExportGetSettingsAsAtomContainer",err);
		CloseComponent(exporter);
		return nil;
	}
	NSData *data = [NSData dataWithBytes:*settings length:GetHandleSize(settings)];
	
	// save current settings to user defaults
	[[NSUserDefaults standardUserDefaults] setValue:data forKey:@"movieExportSettings"];
	
	DisposeHandle(settings);
	
	CloseComponent(exporter);
	
	return data;
}

- (BOOL)writeMovie:(QTMovie *)movie toFile:(NSString *)file withComponent:(NSDictionary *)component withExportSettings:(NSData *)exportSettings
{
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES], QTMovieExport,
								[component objectForKey:@"subtype"], QTMovieExportType,
								[component objectForKey:@"manufacturer"], QTMovieExportManufacturer,
								exportSettings, QTMovieExportSettings,
								nil];
	
	session = [NSApp beginModalSessionForWindow:progressWindow];
	shouldCancel = NO;
	
	BOOL result = [movie writeToFile:file withAttributes:attributes];
	
	if(!result)
	{
		NSLog(@"Couldn't write movie to file");
		return NO;
	}
	
	return YES;
}

#pragma mark Movie delegate methods

- (BOOL)movie:(QTMovie *)movie shouldContinueOperation:(NSString *)op withPhase:(QTMovieOperationPhase)phase atPercent:(NSNumber *)percent withAttributes:(NSDictionary *)attributes;
{
	[NSApp runModalSession:session];
	switch (phase) {
		case QTMovieOperationBeginPhase:
			break;
		case QTMovieOperationUpdatePercentPhase:
			[progressBar setDoubleValue:[percent doubleValue]];
			break;
		case QTMovieOperationEndPhase:
			[NSApp endModalSession:session];
			[progressWindow close];
			break;
		default:
			break;
	}
	return !shouldCancel;
}

#pragma mark GUI methods

- (IBAction)cancelButton:(id)sender;
{
	shouldCancel = YES;
}

@end
