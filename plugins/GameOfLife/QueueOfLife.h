//
//  QueueOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableArray (QueueOfLife)

-(void)enqueue:(id) item;
-(void)enqueueUnique:(id) item;
-(id)peek;
-(id)dequeue;

@end
