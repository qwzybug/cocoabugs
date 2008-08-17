//
//  DaisyCell.m
//  ALife Plugin
//
//  Created by Devin Chalmers on 8/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DaisyCell.h"

#import "Daisy.h"

@implementation DaisyCell

@synthesize daisy, temperature;

- (id)init;
{
	if (!(self = [super init]))
		return nil;
	
	temperature = 0.5;
	
	self.daisy = [[[Daisy alloc] init] autorelease];
	if (random() % 2) {
		self.daisy.type = WHITE_DAISY;
	} else {
		self.daisy.type = BLACK_DAISY;
	}
	
	return self;
}

@end
