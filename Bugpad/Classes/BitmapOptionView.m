//
//  BitmapOptionView.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BugpadAppDelegate.h"

#import "BitmapOptionView.h"
#import "PixelImage.h"

#import "DetailViewController.h"

@implementation BitmapOptionView

@synthesize label;
@synthesize imageView;
@synthesize imagePicker;
@synthesize popover;

@synthesize configuration;
@synthesize simulation;

- (void)dealloc {
	[label release], label = nil;
	[imageView release], imageView = nil;
	[imagePicker release], imagePicker = nil;
	[popover release], popover = nil;
	
	[configuration release], configuration = nil;
	[simulation release], simulation = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame configuration:(NSDictionary *)theConfiguration simulation:(ALifeSimulation *)theSimulation;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	self.configuration = theConfiguration;
	self.simulation = theSimulation;
		
	NSString *keyPath = [configuration valueForKey:@"keyPath"];
	UIImage *image = [simulation valueForKeyPath:keyPath];

	label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height - 20.0, 40.0)];
	label.font = [UIFont boldSystemFontOfSize:12.0];
	label.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	label.numberOfLines = 2;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	label.text = [self.configuration valueForKey:@"title"];
	label.transform = CGAffineTransformMakeRotation(-M_PI / 2);
	label.center = CGPointMake(20.0, frame.size.height/ 2);
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(-1, 0);
	label.backgroundColor = [UIColor clearColor];
	[self addSubview:label];
	
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0, 10.0, frame.size.width - 60.0, frame.size.height - 10.0)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.image = image;
	imageView.userInteractionEnabled = YES;
	imageView.layer.magnificationFilter = kCAFilterNearest;
	imageView.layer.geometryFlipped = YES;
	[self addSubview:imageView];
	
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
	[addButton setTitle:@"+" forState:UIControlStateNormal];
	addButton.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 44.0, imageView.frame.origin.y, 44.0, 44.0);
	[self addSubview:addButton];

	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	editButton.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 64.0, 44.0);
	[self addSubview:editButton];
	
	return self;
}

- (IBAction)imageButtonAction:sender;
{
	if (!self.imagePicker) {
		self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
		self.imagePicker.delegate = self;
		self.popover = [[[UIPopoverController alloc] initWithContentViewController:self.imagePicker] autorelease];
	}
	[self.popover presentPopoverFromRect:imageView.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	UITouch *touch = [[event touchesForView:imageView] anyObject];
	if (touch) {
		[self imageButtonAction:self];
	}
}

- (void)updateWithImage:(UIImage *)image;
{
	[self.simulation setValue:image forKeyPath:[self.configuration valueForKey:@"keyPath"]];
	imageView.image = [self.simulation valueForKeyPath:[self.configuration valueForKey:@"keyPath"]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	[self updateWithImage:image];
	[self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
	[self.popover dismissPopoverAnimated:YES];
}

- (IBAction)editAction:(id)sender;
{
	// TODO hack
	DetailViewController *dvc = ((BugpadAppDelegate *)[UIApplication sharedApplication].delegate).detailViewController;
	
	PixelImage *bitmap = [[[PixelImage alloc] initWithImage:[self.simulation valueForKeyPath:[self.configuration valueForKeyPath:@"keyPath"]]] autorelease];
	BPEditBitmapViewController *evc = [[[BPEditBitmapViewController alloc] initWithBitmap:bitmap] autorelease];
	evc.delegate = self;
	
	[dvc presentModalViewController:evc animated:YES];
}

- (IBAction)addAction:(id)sender;
{
	// TODO hack
	DetailViewController *dvc = ((BugpadAppDelegate *)[UIApplication sharedApplication].delegate).detailViewController;
	
	PixelImage *bitmap = [[[PixelImage alloc] initWithWidth:self.simulation.width height:self.simulation.height] autorelease];
	BPEditBitmapViewController *evc = [[[BPEditBitmapViewController alloc] initWithBitmap:bitmap] autorelease];
	evc.delegate = self;
	
	[dvc presentModalViewController:evc animated:YES];
}

- (void)editBitmapViewController:(BPEditBitmapViewController *)controller finishedEditingWithBitmap:(PixelImage *)bitmap;
{
	[self updateWithImage:bitmap.image];
	UIImageWriteToSavedPhotosAlbum(bitmap.image, nil, nil, nil);
	// TODO hack
	DetailViewController *dvc = ((BugpadAppDelegate *)[UIApplication sharedApplication].delegate).detailViewController;
	[dvc dismissModalViewControllerAnimated:YES];
}

- (void)editBitmapViewControllerCancelled:(BPEditBitmapViewController *)controller;
{
	// TODO hack
	DetailViewController *dvc = ((BugpadAppDelegate *)[UIApplication sharedApplication].delegate).detailViewController;
	[dvc dismissModalViewControllerAnimated:YES];
}

@end
