//
//  Bug.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct _BugMovement {
	int x;
	int y;
	int heritage;
} BugMovement;

@interface Bug : NSObject {
	BugMovement genes[32];
	int food;
	int age;
	int x;
	int y;
}

@property(readwrite) int food;
@property(readwrite) int age;
@property(readwrite) int x;
@property(readwrite) int y;

- (Bug *)initWithFood:(int)myFood andGenes:(BugMovement[])myGenes mutationRate:(float)mutationRate;
- (Bug *)doReproduceWithMutationRate:(float)mutationRate;
- (BugMovement)getMovementForGene:(int)num;
- (void)doEat:(int)amount;
- (void)doDigest:(int)amount;
- (int)hashForGene:(int)num;
// private?
- (BugMovement)randomGene;
@end
