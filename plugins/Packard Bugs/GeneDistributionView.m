//
//  GeneDistributionView.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeneDistributionView.h"


@implementation GeneDistributionView

- (id)initWithFrame:(NSRect)frame;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	// initialize gene count array
	int i, j;
	for (i = 0; i < 31; i++){for(j = 0; j < 31; j++){geneCounts[i][j] = 0;}}
	
	// timer for non-continuous redrawing, cause we don't really need to do that
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
	
	return self;
}

- (void)timerTick:(NSTimer *)theTimer;
{
	if([[self window] isVisible] && needsRedisplay) {
		[self setNeedsDisplay:YES];
	}
}

//- (void)awakeFromNib;
//{
//	[controller addObserver:self
//				 forKeyPath:@"world.ticks"
//					options:NSKeyValueObservingOptionNew
//					context:NULL];
//	
////	[controller addObserver:self
////				 forKeyPath:@"observedGene"
////					options:NSKeyValueObservingOptionNew
////					context:NULL];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
//    if ([keyPath isEqual:@"observedGene"]) {
//		[[change objectForKey:NSKeyValueChangeNewKey] getValue:&gene];
//		[self setNeedsDisplay:YES];
//	} else {
		needsRedisplay = true;
//	}
}

- (void)drawRect:(NSRect)rect;
{
//	int i, j;
//	float rectWidth = [self frame].size.width / 31.0;
//	float rectHeight = [self frame].size.height / 31.0;
//	Bug *bug;
//	BugMovement movement;
//	for (NSMutableArray *row in controller.world.grid) {
//		for (Cell *cell in row) {
//			if (bug = cell.bug) {
//				movement = [bug getMovementForGene:gene];
//				geneCounts[movement.x + 15][movement.y + 15] += 1;
//			}
//		}
//	}
	// draw gene count distribution
	int rectCount = 0;
//	int population = controller.world.population;
	NSRect geneRects[120];
//	for (i = 0; i < 31; i++) {
//		for (j = 0; j < 31; j++) {
//			if (geneCounts[i][j] > 0) {
//				float rectSize = log2(geneCounts[i][j] * 120.0 / population + 1) + 1;
//				geneRects[rectCount] = NSMakeRect(rectWidth * i - (rectSize - rectWidth)/2, rectHeight * j - (rectSize - rectWidth)/2, rectSize, rectSize);
//				rectCount++;
//			}
//			geneCounts[i][j] = 0; // reset count to 0 for next count
//		}
//	}
	[[NSColor colorWithDeviceWhite:0.0 alpha:0.5] set];
	NSRectFillList(geneRects, rectCount);
	needsRedisplay = false;
}

@end
