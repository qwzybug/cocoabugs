//
//  Cell.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Bug.h"

@interface Cell : NSObject {
	Bug *bug;
	bool food;
	int row;
	int col;
}

@property(readwrite) int row;
@property(readwrite) int col;
@property(readwrite) bool food;
@property(readwrite, strong) Bug *bug;

- (id)initWithFood:(bool)myFood atRow:(int)myRow column:(int)myCol;

@end
