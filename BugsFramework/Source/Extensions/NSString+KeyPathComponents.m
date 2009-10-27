//
//  NSString+KeyPathComponents.m
//  BugsFramework
//
//  Created by Devin Chalmers on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+KeyPathComponents.h"


@implementation NSString (KeyPathComponents)

- (NSString *)lastKeyPathComponent;
{
	NSArray *components = [self componentsSeparatedByString:@"."];
	if (components.count > 1) {
		return [components lastObject];
	}
	return nil;
}

- (NSString *)majorKeyPath;
{
	NSArray *components = [self componentsSeparatedByString:@"."];
	if (components.count > 1) {
		return [[components subarrayWithRange:NSMakeRange(0, components.count - 1)] componentsJoinedByString:@"."];
	}
	return self;
}

@end
