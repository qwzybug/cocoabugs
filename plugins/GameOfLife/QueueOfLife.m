//
//  QueueOfLife.m
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "QueueOfLife.h"

@implementation NSMutableArray (QueueOfLife)

- (void)enqueue:(id)item;
{
//	@synchronized(self) {
		[self addObject:item];
//	}
}

- (void)enqueueUnique:(id)item;
{
//	@synchronized(self) {
		for (id member in self) {
			if ([item isEqual:member]) return;
		}
		[self enqueue:item];
//	}
}

-(id)peek;
{
	if ([self count] == 0)
		return nil;
	return [self objectAtIndex:0];
}

- (id)dequeue;
{
//	@synchronized(self) {
		if ([self count] == 0)
			return nil;
		
		id item = [[self objectAtIndex:0] retain];
		[self removeObjectAtIndex:0];
		
		return [item autorelease];
//	}
}

@end
