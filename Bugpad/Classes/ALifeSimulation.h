//
//  ALifeSimulation.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALifeCritter.h"

@interface ALifeSimulation : NSObject {
	int width;
	int height;
	
	BOOL running;
	
	NSMutableSet *critters;
}

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, retain) NSMutableSet *critters;

- (id)initWithConfiguration:(NSDictionary *)configuration;
- (void)update;
- (void)reset;

- (float)sizeForCellAtX:(int)x y:(int)y;
- (UIColor *)colorForCellAtX:(int)x y:(int)y;

- (float)sizeForCritter:(ALifeCritter *)critter;
- (UIColor *)colorForCritter:(ALifeCritter *)critter;

+ (NSString *)name;
+ (NSArray *)configurationOptions;
+ (NSDictionary *)statistics;

@end
