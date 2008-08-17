//
//  LifeModel.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LifeModel.h"


@implementation LifeModel

@synthesize generation, favoriteNumber;

- (id)initWithFavoriteNumber:(int)number;
{
	if (!(self = [super init]))
		return nil;
	
	self.favoriteNumber = number;
	
	return self;
}

- (void)dealloc;
{
	NSLog(@"Deallocing LifeModel");
	
	[super dealloc];
}

- (void)update;
{
	self.generation++;
	NSLog(@"%d", generation);
}

@end
