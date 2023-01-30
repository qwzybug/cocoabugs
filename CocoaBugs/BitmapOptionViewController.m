//
//  BitmapOptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BitmapOptionViewController.h"


@implementation BitmapOptionViewController {
    int _selectedImageIndex;
}

@synthesize name, builtInImages;
@synthesize image, imageView;

+ (BitmapOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[self alloc] initWithOptionDictionary:options];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"BitmapOptionView" bundle:[NSBundle mainBundle]]))
		return nil;
	
	NSString *thePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"BuiltInImages" ofType:@"plist"];
	builtInImages = [NSMutableArray arrayWithObject:@"Pick an image..."];
	builtInImages = [builtInImages arrayByAddingObjectsFromArray:[NSArray arrayWithContentsOfFile:thePath]];
	
	self.name = [options objectForKey:@"name"];
	self.title = [options objectForKey:@"title"];
	
	return self;
}

- (void)dealloc;
{
	[self.view removeFromSuperview];
	
	imageView = nil;
	image = nil;
	
}

- (void)awakeFromNib;
{
	[titleField setStringValue:self.title];
	self.selectedImageIndex = 1;
}

- (int)selectedImageIndex;
{
    return _selectedImageIndex;
}

- (void)setSelectedImageIndex:(int)imageIndex;
{
    _selectedImageIndex = imageIndex;
    
	if (_selectedImageIndex) {
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
