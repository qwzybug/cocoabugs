/*
 * View for a Von Neumann neighborhood.
 * Hardcoded to 32px square for now.
 */

#import <Cocoa/Cocoa.h>

#import "BugsColoringWindowController.h"

@interface BugNeighborhoodView : NSControl {
	int neighborhoodCode;
	NSRect rects[5];
	IBOutlet BugsColoringWindowController *controller;
	bool enabled;
}

@property(assign, readwrite) bool enabled;
@property(assign, readwrite) int neighborhoodCode;

@end
