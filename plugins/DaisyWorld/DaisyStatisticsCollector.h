//
//  StatisticsCollector.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DaisyWorld;

@interface DaisyStatisticsCollector : NSObject {
	DaisyWorld *world;
//	
//	NSSet *generation;
//	NSSet *currentNumber;
}

//@property (readwrite, retain) NSSet *generation;
//@property (readwrite, retain) NSSet *currentNumber;
//
- (id)initWithWorld:(DaisyWorld *)theWorld;
//- (void)updateStatistics;

@end
