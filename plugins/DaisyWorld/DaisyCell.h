//
//  DaisyCell.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 8/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Daisy;

@interface DaisyCell : NSObject {
	Daisy *daisy;
	float temperature;
}

@property (readwrite, retain) Daisy *daisy;
@property (readwrite, assign) float temperature;

@end
