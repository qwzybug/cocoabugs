//
//  CellOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 4/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CellOfLife : NSObject {
	int row;
	int column;
	BOOL alive;
	NSMutableSet *neighbors;
}

@property(readonly) int row;
@property(readonly) int column;
@property(readwrite) BOOL alive;
@property(readonly) NSMutableSet *neighbors;

- (id)initWithRow:(int)r column:(int)c;
- (int)liveNeighbors;

@end
