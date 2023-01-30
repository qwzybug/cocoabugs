//
//  WorldView.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class World;
@class Cell;
@class Bug;

@interface WorldView : NSView {
	World *world;
	int colorGene;
}

@property (readwrite, strong) World *world;
@property (nonatomic, assign) int colorGene;

@end
