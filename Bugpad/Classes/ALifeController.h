//
//  ALifeController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALifeCritter.h"

@protocol ALifeController <NSObject>

// plugin information
+ (NSString *)name;
+ (NSArray *)configurationOptions;

// initialize with a configuration dictionary
- (id)initWithConfiguration:(NSDictionary *)configuration;
// reset the simulation
- (void)reset;
// update the simulation
- (void)update;
// get the properties for the simulation
// includes "statistics" key, for statistics descriptions
- (NSDictionary *)properties;
// the object to listen to for statistics updates
- (id)statisticsCollector;

// also need accessors for:
// statistics keys
// configuration options
// setting configuration
// maybe generating a plist for the current configuration?

// EXPERIMENTAL
- (void)showColorWindow;
- (BOOL)alive;
- (void)setCollectActivity:(BOOL)collectActivity;
- (void)exportActivity:(NSString *)path;
- (NSString *)stepKeyPath;

@end
