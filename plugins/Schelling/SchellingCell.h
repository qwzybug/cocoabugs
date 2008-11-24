//
//  CellOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 4/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SchellingCell : NSObject {
	int row;
	int column;
	int race;
	int zero;
	int one;
	int two;
	int three;
	int four;
	int five;
	int six;
	int seven;
	int eight;
	NSMutableSet *neighbors;
	SchellingCell *nearEmpty;
}

@property(readonly) int row;
@property(readonly) int column;
@property(readwrite) int race;
@property(readwrite) int zero;
@property(readwrite) int one;
@property(readwrite) int two;
@property(readwrite) int three;
@property(readwrite) int four;
@property(readwrite) int five;
@property(readwrite) int six;
@property(readwrite) int seven;
@property(readwrite) int eight;
@property(readonly) NSMutableSet *neighbors;
//@property(readwrite) NSMutableSet *nearEmpty;

- (id)initWithRow:(int)r column:(int)c;
- (int)liveNeighbors;
- (int)sameNeighbors;
- (id)closeCells;
//- (id)nearEmpty;
@end
