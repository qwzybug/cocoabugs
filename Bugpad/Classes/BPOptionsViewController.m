//
//  BPOptionsViewController.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BPOptionsViewController.h"

#import "BPIntegerOptionView.h"
#import "BPFloatOptionView.h"
#import "BitmapOptionView.h"

@implementation BPOptionsViewController

@synthesize delegate;
@synthesize configurationViews;
@synthesize simulation;

@synthesize scrollView;

- (void)viewDidLoad;
{
	[self updateDisplay];
	
	[super viewDidLoad];
}

- (void)updateDisplay;
{
	for (UIView *view in self.scrollView.subviews) {
		[view removeFromSuperview];
	}
	
	NSArray *configurations = [[simulation class] configurationOptions];
	NSMutableArray *newConfigurationViews = [NSMutableArray arrayWithCapacity:configurations.count];
	
	float delta = 0.0;
	for (NSDictionary *configuration in configurations) {
		UIView *optionView = nil;
		if ([[configuration valueForKey:@"type"] isEqual:@"Integer"]) {
			optionView = [[[BPIntegerOptionView alloc] initWithFrame:CGRectMake(delta, 0.0, 100.0, 200.0) configuration:configuration simulation:simulation] autorelease];
		}
		else if ([[configuration valueForKey:@"type"] isEqual:@"Float"]) {
			optionView = [[[BPFloatOptionView alloc] initWithFrame:CGRectMake(delta, 0.0, 100.0, 200.0) configuration:configuration simulation:simulation] autorelease];
		}
		else if ([[configuration valueForKey:@"type"] isEqual:@"Bitmap"]) {
			optionView = [[[BitmapOptionView alloc] initWithFrame:CGRectMake(delta, 0.0, 200.0, 190.0) configuration:configuration simulation:simulation] autorelease];
		}
		[newConfigurationViews addObject:optionView];
		[self.scrollView addSubview:optionView];
		delta += optionView.frame.size.width;
	}
	self.scrollView.contentSize = CGSizeMake(delta, 200.0);
	
	self.configurationViews = newConfigurationViews;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.configurationViews = nil;
}


- (void)dealloc {
	[simulation release], simulation = nil;
	[configurationViews release], configurationViews = nil;
	[scrollView release], scrollView = nil;
	
    [super dealloc];
}


@end
