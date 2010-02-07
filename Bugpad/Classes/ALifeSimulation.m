//
//  ALifeSimulation.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ALifeSimulation.h"


@implementation ALifeSimulation

@synthesize width, height, critters;

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super init]))
		return nil;
	
	return self;
}

- (void)update;
{
	NSAssert1(NO, @"Implement -update in %@", NSStringFromClass([self class]));
}

@end
