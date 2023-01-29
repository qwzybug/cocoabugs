//
//  FloatOptionViewController.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FloatOptionViewController.h"


@implementation FloatOptionViewController

@synthesize name, title, slider;
@synthesize minValue, maxValue;
@synthesize value;

+ (FloatOptionViewController *)controllerWithOptions:(NSDictionary *)options;
{
	return [[self alloc] initWithOptionDictionary:options];
}

- (id)initWithOptionDictionary:(NSDictionary *)options;
{
	if (!(self = [super initWithNibName:@"FloatOptionView" bundle:nil]))
		return nil;
	
	minValue = [[options objectForKey:@"minValue"] floatValue];
	maxValue = [[options objectForKey:@"maxValue"] floatValue];
	
	self.value = [options objectForKey:@"default"];
	self.name = [options objectForKey:@"name"];
	self.title = [options objectForKey:@"title"];
	
	return self;
}

- (void)dealloc;
{
	[self.view removeFromSuperview];
	
}

@end
