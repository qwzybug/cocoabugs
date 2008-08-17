//
//  LifeModel.h
//  ALife Plugin
//
//  Created by Devin Chalmers on 7/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LifeModel : NSObject {
	int generation;
	int favoriteNumber;
}

@property (readwrite, assign) int generation;
@property (readwrite, assign) int favoriteNumber;

- (void)update;

- (id)initWithFavoriteNumber:(int)number;

@end
