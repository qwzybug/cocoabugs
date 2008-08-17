//
//  OperationOfLife.h
//  ThreadOfLife
//
//  Created by Devin Chalmers on 3/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GameOfLife, CellOfLife;

#define OP_READ -1
#define OP_LIVE	0
#define OP_DEAD 1

@interface OperationOfLife : NSObject {
	CellOfLife *cell;
	GameOfLife *game;
	int type;
}

@property(readonly) GameOfLife *game;
@property(readonly) CellOfLife *cell;
@property(readonly) int type;

- (id)initWithGame:(GameOfLife *)lifeGame cell:(CellOfLife *)lifeCell type:(int)opType;
- (void)go;

@end
