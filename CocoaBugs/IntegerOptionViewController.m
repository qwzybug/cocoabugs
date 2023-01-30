//
//  OptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IntegerOptionViewController.h"


@implementation IntegerOptionViewController

@synthesize name, title, slider;
@synthesize minValue, maxValue;
@synthesize value;

+ (IntegerOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[self alloc] initWithOptionDictionary:options];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"IntegerOptionView" bundle:[NSBundle mainBundle]]))
		return nil;

	minValue = [[options objectForKey:@"minValue"] intValue];
	maxValue = [[options objectForKey:@"maxValue"] intValue];
	
	self.value = [options objectForKey:@"default"];
	self.name = [options objectForKey:@"name"];
	self.title = [options objectForKey:@"title"];
	
	return self;
}

- (void)dealloc;
{
	[self.view removeFromSuperview];
	
}

- (void)awakeFromNib;
{
	int numAllowedValues = maxValue - minValue + 1;
	[slider setNumberOfTickMarks:numAllowedValues];	
}

@end
