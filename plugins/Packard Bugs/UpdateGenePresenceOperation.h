//
//  UpdateGenePresenceOperation.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BugsStatistics;

@interface UpdateGenePresenceOperation : NSOperation {
	NSSet *allBugs;
	NSCountedSet *accumulatedGenePresence;
	BugsStatistics *statistics;
}

- (id)initWithBugs:(NSSet *)bugs statistics:(BugsStatistics *)inStatistics accumulatedGenePresence:(NSCountedSet *)inAccumulatedGenePresence;

@end
