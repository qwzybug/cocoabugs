//
//  StatisticsView.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 3/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsView.h"
#import "StatisticsData.h"

@implementation StatisticsView

@synthesize title, stats;

- (void)dealloc;
{
	self.stats = nil;
	
	[super dealloc];
}

- (void)setStats:(StatisticsData *)newStats;
{
	if (stats) {
		[stats removeObserver:self forKeyPath:@"cursor"];
		[stats release];
	}
	
	stats = [newStats retain];
	
	if (stats) {
		[stats addObserver:self
				forKeyPath:@"cursor"
				   options:NSKeyValueObservingOptionNew
				   context:NULL];	
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"cursor"]) {
		int cursor;
		[[change objectForKey:NSKeyValueChangeNewKey] getValue:&cursor];
		if ((cursor % 10) == 0 && [[self window] isVisible])
			[self setNeedsDisplay:YES];
	}
}

//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawRect:(NSRect)rect;
{
	if (!stats)
		return;
	
	NSColor *dataColor, *labelColor, *gridColor, *dividerColor;
	
	if (![NSGraphicsContext currentContextDrawingToScreen]) {
		dataColor = [NSColor blackColor];
		labelColor = [NSColor blackColor];
		gridColor = [NSColor colorWithDeviceWhite:0.8 alpha:0.8];
		dividerColor = [NSColor blackColor];
    } else {
		dataColor = [NSColor colorWithDeviceWhite:0.7 alpha:0.9];
		labelColor = [NSColor colorWithDeviceWhite:0.8 alpha:0.9];
		gridColor = [NSColor colorWithDeviceWhite: 0.3 alpha:0.9];
		dividerColor = [NSColor colorWithDeviceWhite: 0.3 alpha:0.9];
	}
	
	
	float width = [self frame].size.width;
	float height = [self frame].size.height - 20.0;
	
	int rectCount = 0;
	
	NSSet *data;
	int i, c = 0;
	for (i = 0; i < stats.size; i++) {
		c += [[stats getDataSet:i] count];
	}
	if (title == @"Gene survival") NSLog(@"Counted %d rects", c);
	
	NSRect rects[c];
	
	// find max data point
	int max = [stats maxValue];
//	for (i = 0; i < 1000; i++) {
//		int datum = [stats getDataPoint:i];
//		max = datum > max ? datum : max;
//	}
		
	// assemble data points
	float datumValue;
	float vscale = (float)height / max;
	
	// draw grid lines
	[gridColor set];
	for (i = 100; i < max; i += 100) {
		NSRectFill(NSMakeRect(0.0, i * vscale + 2.0, width, 1.0));
	}
	
	int step = stats.size / width;
	for (i = 0; i < stats.size; i += step) {
//		int datum = [stats getDataPoint:i];
		data = [stats getDataSet:i];
		if (!data) continue;
		for (NSNumber *datum in data) {
			datumValue = [datum floatValue];
			if (!datumValue) continue;
			rects[rectCount] = NSMakeRect(i * width / stats.size, datumValue * vscale + 2.0, 1.0, 1.0);
			rectCount++;
		}
	}
	// draw data points
	[dataColor set];
	NSRectFillList(rects, rectCount);
	
	// draw title
	NSPoint point = NSMakePoint(3.0, height + 4.0);
	[self.title drawAtPoint:point
			 withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:labelColor, NSForegroundColorAttributeName,
							[NSFont systemFontOfSize:10.0], NSFontAttributeName, nil]];
		
	// draw border
	[dividerColor set];
	NSRectFill(NSMakeRect(0.0, height + 19.0, width, 1.0));
	
	if (title == @"Gene survival") NSLog(@"%d rects filled", rectCount);
}

@end
