//
//  NSDictionary_Merging.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary_Merging.h"


@implementation NSDictionary (Merging)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)other;
{
	NSMutableDictionary *merged = [NSMutableDictionary dictionaryWithDictionary:self];
	for (id key in other) {
		[merged setObject:[other objectForKey:key] forKey:key];
	}
	return [NSDictionary dictionaryWithDictionary:merged];
}

@end
