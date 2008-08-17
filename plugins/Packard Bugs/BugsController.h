//
//  BugsController.h
//  ALife Plugin
//

#import <Cocoa/Cocoa.h>
#import "ALifeController.h"

@class World, WorldView, BugsStatistics;

@interface BugsController : NSObject <ALifeController> {
	World *world;
	WorldView *view;
	BugsStatistics *statistics;
	NSDictionary *properties;
	// add instance variables here
}

@property (readonly) NSDictionary *properties;

// add method declarations here
+ (NSString *)name;

@end
