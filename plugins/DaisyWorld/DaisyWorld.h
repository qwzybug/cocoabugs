//
//  LifeModel.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DaisyCell;

@interface DaisyWorld : NSObject {
	int step;
	int size;
	
	float sunLuminance;
	float sunLuminanceDelta;
	
	NSMutableArray *terrain;
}

@property (readwrite, assign) int step;
@property (readwrite, retain) NSMutableArray *terrain;

@property (readwrite, assign) float sunLuminance;
@property (readwrite, assign) float sunLuminanceDelta;

- (void)update;

@end
