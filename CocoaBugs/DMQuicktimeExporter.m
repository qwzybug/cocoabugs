//
//  DMQuicktimeExporter.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DMQuicktimeExporter.h"


@implementation DMQuicktimeExporter

+ (id)movieExporter;
{
	return [[[self alloc] init] autorelease];
}

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	// initialize a blank movie
	NSString *tempName = [NSString stringWithCString:tmpnam(nil) 
											encoding:[NSString defaultCStringEncoding]];
	mMovie = [[QTMovie alloc] initToWritableFile:tempName error:nil];
	[mMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute];
	
	return self;
}

- (void)addFrameFromView:(NSView *)view;
{
	NSLog(@"Adding image...");
	NSImage *image;
	NSDictionary *imageAttributes = [NSDictionary dictionaryWithObjectsAndKeys:@"jpeg", QTAddImageCodecType,
									 [NSNumber numberWithLong:codecNormalQuality], QTAddImageCodecQuality, nil];
	image = [[NSImage alloc] initWithData:[view dataWithPDFInsideRect:[view frame]]];
	[mMovie addImage:image
		 forDuration:QTMakeTime(1, 30)
	  withAttributes:imageAttributes];
	[image release];	
}

- (void)exportMovie:(NSString *)filePath;
{
	[mMovie writeToFile:filePath
		 withAttributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] 
													forKey:QTMovieFlatten]];
}

- (void)dealloc;
{
	[mMovie release];
	[super dealloc];
}

@end
