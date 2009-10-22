//
//  NSDictionary_Merging.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Merging)

- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)other;

@end
