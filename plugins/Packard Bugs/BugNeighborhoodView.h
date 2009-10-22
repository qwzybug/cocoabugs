/*
 * View for a Von Neumann neighborhood.
 * Hardcoded to 32px square for now.
 */

#import <Cocoa/Cocoa.h>
#import "BugsController.h"

@interface BugNeighborhoodView : NSControl <NSCoding> {
	int neighborhoodCode;
	NSRect rects[5];
	IBOutlet id controller;
	bool enabled;
}
@property(assign, readwrite) bool enabled;
@property(assign, readwrite) int neighborhoodCode;
@end
