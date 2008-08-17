//
//  LifeController.h
//  ALife Plugin
//

#import <Cocoa/Cocoa.h>
#import "ALifeController.h"

@class DaisyWorld, DaisyWorldView, DaisyStatisticsCollector;

@interface DaisyWorldController : NSObject <ALifeController> {
	DaisyWorld *world;
	DaisyWorldView *view;
	DaisyStatisticsCollector *statistics;
	NSDictionary *properties;
	// add instance variables here
}

@property (readonly) NSDictionary *properties;

// add method declarations here

@end
