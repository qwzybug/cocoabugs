#import "BugNeighborhoodView.h"

@implementation BugNeighborhoodView

@synthesize neighborhoodCode;

- (id)initWithFrame:(NSRect)frame;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	neighborhoodCode = 0;
	
	rects[0] = NSMakeRect(11.0, 22.0, 10.0, 10.0); // top-middle
	rects[1] = NSMakeRect(0.0, 11.0, 10.0, 10.0);  // middle-left
	rects[2] = NSMakeRect(11.0, 11.0, 10.0, 10.0); // middle
	rects[3] = NSMakeRect(22.0, 11.0, 10.0, 10.0); // middle-right
	rects[4] = NSMakeRect(11.0, 0.0, 10.0, 10.0);  // bottom-middle
	
	return self;
}

- (void)awakeFromNib;
{
	neighborhoodCode = 0;
	
	rects[0] = NSMakeRect(11.0, 22.0, 10.0, 10.0); // top-middle
	rects[1] = NSMakeRect(0.0, 11.0, 10.0, 10.0);  // middle-left
	rects[2] = NSMakeRect(11.0, 11.0, 10.0, 10.0); // middle
	rects[3] = NSMakeRect(22.0, 11.0, 10.0, 10.0); // middle-right
	rects[4] = NSMakeRect(11.0, 0.0, 10.0, 10.0);  // bottom-middle
}

- (void)drawRect:(NSRect)rect;
{
	[[NSColor blackColor] set];
	int i;
	for (i = 0; i < 5; i++) {
		NSFrameRect(rects[i]);
		if (neighborhoodCode & 1 << i) {
			NSRectFill(rects[i]);
		}
	}
}

- (NSInteger)sendActionOn:(NSEventMask)mask;
{
    return NSEventMaskLeftMouseUp;
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int i;
	for (i = 0; i < 5; i++) {
		if (NSPointInRect(point, rects[i])) {
			neighborhoodCode ^= 1 << i;
		}
	}
	[self setNeedsDisplay:YES];
	
	[controller setGene:neighborhoodCode];
}

@end
