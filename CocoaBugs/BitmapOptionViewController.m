//
//  BitmapOptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BitmapOptionViewController.h"


@implementation BitmapOptionViewController

@synthesize name, title, builtInImages, selectedImageIndex;
@synthesize image, imageView;

+ (BitmapOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[[self alloc] initWithOptionDictionary:options] autorelease];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"BitmapOptionView" bundle:[NSBundle mainBundle]]))
		return nil;
	
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
	
	[imageView release], imageView = nil;
	[image release], image = nil;
	
	[super dealloc];
}

- (void)awakeFromNib;
{
	[titleField setStringValue:self.title];
	self.selectedImageIndex = 1;
}

- (int)selectedImageIndex
{
    return selectedImageIndex;
}

- (void)setSelectedImageIndex:(int)imageIndex;
{
	if (imageIndex) {
		NSString *selectedImageName = [builtInImages objectAtIndex:imageIndex];
		NSImage *newImage = [NSImage imageNamed:selectedImageName];
		self.image = newImage;
	}
}

- (NSData *)value;
{
	return [self.image TIFFRepresentationUsingCompression:NSTIFFCompressionLZW factor:0];
}

@end
