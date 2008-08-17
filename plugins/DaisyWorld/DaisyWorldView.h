//
//  LifeView.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DaisyWorld;

@interface DaisyWorldView : NSView {
	DaisyWorld *simulation;
}

- (void)setSimulation:(DaisyWorld *)simulation;

@end
