//
//  BugsController.h
//  ALife Plugin
//

#import <Cocoa/Cocoa.h>

@class World, WorldView, BugsStatistics, BugsColoringWindowController;

@interface BugsController : NSObject <ALifeController> {
	World *world;
	WorldView *view;
	BugsStatistics *statistics;
	NSDictionary *properties;
	// add instance variables here
	
	BugsColoringWindowController *coloringWindowController;
	int observedGene;
	
	float populationDensity;
	NSImage *foodImage;
}

@property (readonly) NSDictionary *properties;
@property (readwrite, retain) World *world;
@property (nonatomic, retain) NSImage *foodImage;

@property (nonatomic, assign) int observedGene;
@property (nonatomic, assign) float populationDensity;

// add method declarations here
+ (NSString *)name;

- (void)showColorWindow;
- (void)redrawDisplay;

@end
