    //
//  BPEditBitmapViewController.m
//  Bugpad
//
//  Created by Devin Chalmers on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BPEditBitmapViewController.h"

#import "PixelImage.h"
#import "BPEditBitmapView.h"

@implementation BPEditBitmapViewController

@synthesize imageView;

@synthesize delegate;
@synthesize bitmap;

- (void)dealloc;
{
	[imageView release], imageView = nil;
	[bitmap release], bitmap = nil;
	
	[super dealloc];
}

- (id)initWithBitmap:(PixelImage *)inBitmap;
{
	if (!(self = [super initWithNibName:nil bundle:nil]))
		return nil;
	
	self.bitmap = inBitmap;
	
	return self;
}

- (void)viewDidLoad;
{
	self.imageView.bitmap = self.bitmap;
}

- (IBAction)cancelAction:(id)sender;
{
	[self.delegate editBitmapViewControllerCancelled:self];
}

- (IBAction)doneAction:(id)sender;
{
	[self.delegate editBitmapViewController:self finishedEditingWithBitmap:self.bitmap];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (CGRectContainsPoint(self.imageView.frame, point)) {
		return imageView;
	}
	return nil;
}

@end
