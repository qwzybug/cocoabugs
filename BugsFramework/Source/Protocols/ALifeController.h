//
//  ALifeController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ALifeController <NSObject>

// plugin information
+ (NSString * _Nonnull)name;
+ (NSArray * _Nonnull)configurationOptions;

// initialize with a configuration dictionary
- (id _Nonnull)initWithConfiguration:(NSDictionary * _Nonnull)configuration;
// reset the simulation
- (void)reset;
// update the simulation
- (void)update;
// get a view for the simulation
- (NSView * _Nonnull)view;
// get the properties for the simulation
// includes "statistics" key, for statistics descriptions
- (NSDictionary * _Nonnull)properties;
// the object to listen to for statistics updates
- (id _Nonnull)statisticsCollector;

// also need accessors for:
// statistics keys
// configuration options
// setting configuration
// maybe generating a plist for the current configuration?

// EXPERIMENTAL
- (NSWindow * _Nullable)coloringWindow;
- (BOOL)alive;
- (void)setCollectActivity:(BOOL)collectActivity;
- (void)exportActivity:(NSString * _Nonnull)path;
- (NSString * _Nullable)stepKeyPath;

@end
