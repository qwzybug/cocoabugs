//
//  BugsController.h
//  ALife Plugin
//

#import <Cocoa/Cocoa.h>
#import "ALifeController.h"

@class World, WorldView, BugsStatistics, BugsColoringWindowController;

@interface BugsController : NSObject <ALifeController> {
	World *world;
	WorldView *view;
	BugsStatistics *statistics;
	NSDictionary *properties;
	// add instance variables here
	
	BugsColoringWindowController *coloringWindowController;
	int observedGene;
}

@property (readonly) NSDictionary *properties;
@property (readwrite, retain) World *world;

@property (nonatomic, assign) int observedGene;

// add method declarations here
+ (NSString *)name;

- (void)showColorWindow;
- (void)redrawDisplay;

@end
