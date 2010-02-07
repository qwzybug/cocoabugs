//
//  Cell.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"


@implementation Cell

@synthesize bug, food, row, col;

- (id)initWithFood:(bool)myFood atRow:(int)myRow column:(int)myCol;
{
	if (!(self = [super init]))
		return nil;
	
	food = myFood;
	row = myRow;
	col = myCol;
	
	return self;
}

- (void)dealloc;
{
	self.bug = nil;
	
	[super dealloc];
}

@end
