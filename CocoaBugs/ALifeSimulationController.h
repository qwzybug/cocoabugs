//
//  ALifeSimulationController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeController.h"

@interface ALifeSimulationController : NSObject {
	id<ALifeController> lifeController;
	NSDictionary *configuration;
}

@property(readwrite, retain) id<ALifeController> lifeController;
@property(readwrite, retain) NSDictionary *configuration;

- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;

@end
