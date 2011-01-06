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
@synthesize running;

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

- (void)reset;
{
	NSAssert1(NO, @"Implement -reset in %@", NSStringFromClass([self class]));
}

+ (NSString *)name;
{
	NSAssert1(NO, @"Implement +name in %@", NSStringFromClass(self));
}

+ (NSArray *)configurationOptions;
{
	NSAssert1(NO, @"Implement +name in %@", NSStringFromClass(self));
	return nil;
}

@end
