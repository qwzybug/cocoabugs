//
//  NSArray+Shuffling.m
//  BugsFramework
//
//  Created by Devin Chalmers on 10/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Shuffling.h"


@implementation NSArray (Shuffling)

- (NSArray *)shuffledArray;
{
	NSMutableArray *shuffled = [NSMutableArray arrayWithArray:self];
	int count = [shuffled count];
	for (int i = 0; i < count; ++i) {
		[shuffled exchangeObjectAtIndex:i withObjectAtIndex:(random() % count)];
	}
	return [NSArray arrayWithArray:shuffled];
}

@end
