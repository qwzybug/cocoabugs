//
//  LifeView.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LifeView.h"

#import "ALifeSimulation.h"
#import "ALifeCritter.h"

@implementation LifeView

@synthesize simulation;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    float dx = self.bounds.size.width / simulation.width;
	float dy = self.bounds.size.height / simulation.height;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	for (int row = 0; row < simulation.height; row++) {
		for (int col = 0; col < simulation.width; col++) {
			UIColor *color = [simulation colorForCellAtX:col y:row];
			if (!color) continue;
			
			float size = [simulation sizeForCellAtX:col y:row];
			
			CGRect rect = CGRectMake(col * dx + (1-size)/2, row * dy + (1-size)/2, size * dx, size * dy);
			CGContextSetFillColorWithColor(ctx, color.CGColor);
			CGContextFillRect(ctx, rect);
		}
	}
	
	for (ALifeCritter *critter in simulation.critters) {
		UIColor *color = [simulation colorForCritter:critter];
		if (!color) continue;
		
		float size = [simulation sizeForCritter:critter];
		
		CGRect rect = CGRectMake(critter.x * dx + (1-size)/2, critter.y * dy + (1-size)/2, size * dx, size * dy);
		CGContextSetFillColorWithColor(ctx, color.CGColor);
		CGContextFillRect(ctx, rect);
	}
	
//	for (ALifeCritter *critter in simulation.critters) {
//		CGRect critterRect = CGRectMake(critter.x * dx, critter.y * dy, dx, dy);
//		CGContextFillRect(ctx, critterRect);
//	}
}

- (void)dealloc {
    [super dealloc];
}


@end
