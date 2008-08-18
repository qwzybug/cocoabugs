//
//  BitmapOptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BitmapOptionViewController.h"


@implementation BitmapOptionViewController

@synthesize name, shuffling, title, builtInImages, selectedImageIndex;

+ (BitmapOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[[self alloc] initWithOptionDictionary:options] autorelease];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"BitmapOptionView" bundle:[NSBundle mainBundle]]))
		return nil;
	
	// no bitmap shuffling, yet
	shuffling = NO;
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"BuiltInImages" ofType:@"plist"];
	builtInImages = [[NSMutableArray arrayWithObject:@"Pick an image..."] retain];
	builtInImages = [[builtInImages arrayByAddingObjectsFromArray:[NSArray arrayWithContentsOfFile:thePath]] retain];
	NSLog([builtInImages description]);
	
	self.name = [options objectForKey:@"name"];
	self.title = [options objectForKey:@"title"];
	
	return self;
}

- (void)dealloc;
{
	self.name = nil;
	self.title = nil;
	[self.view removeFromSuperview];
	
	[super dealloc];
}

- (void)awakeFromNib;
{
	[titleField setStringValue:self.title];
}

- (void)setSelectedImageIndex:(int)imageIndex;
{
	if (imageIndex) {
		NSString *selectedImageName = [builtInImages objectAtIndex:imageIndex];
		[imageView setImage:[NSImage imageNamed:selectedImageName]];
	}
}

- (NSData *)value;
{
//	NSImage *image = [imageView image];
//	NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
//	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:width pixelsHigh:height bitsPerSample:1 samplesPerPixel:1 hasAlpha:0 isPlanar:1 colorSpaceName:NULL bytesPerRow:0 bitsPerPixel:1];
//	int width = [image size].width;
//	int height = [image size].height;

//	int i, j;
//	NSMutableData *data = [NSMutableData dataWithLength:[image size].width * [image size].height];
//	BOOL sample;
//	for (i = 0; i < [image size].height; i++) {
//		for (j = 0; j < [image size].width; j++) {
//			sample = [[bitmap colorAtX:i y:j] brightnessComponent] < 0.5;
//			[data appendBytes:&sample length:1];
//		}
//	}
	
	return [[imageView image] TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:0];
}

@end
