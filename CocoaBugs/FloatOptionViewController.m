//
//  FloatOptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FloatOptionViewController.h"


@implementation FloatOptionViewController

@synthesize name, title, shuffling, delta;

+ (FloatOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[[self alloc] initWithOptionDictionary:options] autorelease];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"FloatOptionView" bundle:[NSBundle mainBundle]]))
		return nil;
	
	minValue = [[options objectForKey:@"minValue"] floatValue];
	maxValue = [[options objectForKey:@"maxValue"] floatValue];
	defaultValue = [[options objectForKey:@"default"] floatValue];
	
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
	[slider setMinValue:minValue];
	[slider setMaxValue:maxValue];
	[slider setFloatValue:defaultValue];
	
	[titleField setStringValue:self.title];
	
	[shuffleDial setMinValue:0];
	[shuffleDial setMaxValue:(maxValue - minValue)/2];
	[shuffleDial setIntValue:0];
	
	[minValueField setStringValue:[NSString stringWithFormat:@"%f", minValue]];
	[maxValueField setStringValue:[NSString stringWithFormat:@"%f", maxValue]];
	
	[currentValueField setStringValue:[NSString stringWithFormat:@"%f", defaultValue]];
}

- (NSNumber *)value;
{
	if (shuffling)
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:[slider floatValue]], @"principalValue",
														  [NSNumber numberWithFloat:delta], @"delta",
														  [NSNumber numberWithBool:YES], @"shuffle", nil];
	else
		return [NSNumber numberWithFloat:[slider floatValue]];
}

- (IBAction)sliderValueChanged:(id)sender;
{
	[currentValueField setStringValue:[NSString stringWithFormat:@"%f", [slider floatValue]]];
}

- (void)setShuffling:(BOOL)isShuffling;
{
	shuffling = isShuffling;
	[shuffleDial setHidden:!shuffling];
	[shuffleLabel setHidden:!shuffling];
	[plusMinusLabel setHidden:!shuffling];
}

@end
