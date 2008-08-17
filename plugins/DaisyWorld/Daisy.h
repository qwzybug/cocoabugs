//
//  Daisy.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 8/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define WHITE_DAISY 0
#define BLACK_DAISY 1

@interface Daisy : NSObject {
	int type;
}

@property (readwrite, assign) int type;

@end
