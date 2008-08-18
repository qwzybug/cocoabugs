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
	return [[imageView image] TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:0];
}

@end
