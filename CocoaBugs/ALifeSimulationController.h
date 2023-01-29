//
//  ALifeSimulationController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALifeSimulationController : NSObject {
	id<ALifeController> lifeController;
	NSDictionary *configuration;
}

@property(readwrite, strong) id<ALifeController> lifeController;
@property(readwrite, strong) NSDictionary *configuration;

+ (id)controllerWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration sampling:(NSDictionary *)sampling;
- (id)initWithSimulationClass:(Class <ALifeController>)modelClass configuration:(NSDictionary *)configuration;

@end
