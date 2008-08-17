//
//  OptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IntegerOptionViewController.h"


@implementation IntegerOptionViewController

@synthesize name, title, shuffling, delta;

+ (IntegerOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[[self alloc] initWithOptionDictionary:options] autorelease];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"IntegerOptionView" bundle:[NSBundle mainBundle]]))
		return nil;

	minValue = [[options objectForKey:@"minValue"] intValue];
	maxValue = [[options objectForKey:@"maxValue"] intValue];
	defaultValue = [[options objectForKey:@"default"] intValue];
	
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
	[slider setIntValue:defaultValue];
	
	[shuffleDial setMinValue:0];
	[shuffleDial setMaxValue:(maxValue - minValue)/2];
	[shuffleDial setIntValue:0];
	
	int numAllowedValues = maxValue - minValue + 1;
	if (numAllowedValues < 80) {
		[slider setNumberOfTickMarks:numAllowedValues];
		[slider setAllowsTickMarkValuesOnly:YES];
	}
	
	[titleField setStringValue:self.title];
	
	[minValueField setStringValue:[NSString stringWithFormat:@"%d", minValue]];
	[maxValueField setStringValue:[NSString stringWithFormat:@"%d", maxValue]];
	
	[currentValueField setStringValue:[NSString stringWithFormat:@"%d", defaultValue]];
}
				  
- (NSNumber *)value;
{
	if (shuffling)
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[slider intValue]], @"principalValue",
														  [NSNumber numberWithInt:delta], @"delta",
														  [NSNumber numberWithBool:YES], @"shuffle", nil];
	else
		return [NSNumber numberWithInt:[slider intValue]];
}

- (IBAction)sliderValueChanged:(id)sender;
{
	[currentValueField setStringValue:[NSString stringWithFormat:@"%d", [slider intValue]]];
}

- (void)setShuffling:(BOOL)isShuffling;
{
	shuffling = isShuffling;
	[shuffleDial setHidden:!shuffling];
	[shuffleLabel setHidden:!shuffling];
	[plusMinusLabel setHidden:!shuffling];
}

@end
