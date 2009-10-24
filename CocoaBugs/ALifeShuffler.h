//
//  ALifeShuffler.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALifeShuffler : NSObject {

}

+ (id)shuffleType:(NSString *)type withOptions:(NSDictionary *)options;
+ (id)shuffleType:(NSString *)type min:(NSNumber *)min max:(NSNumber *)max;

@end

@protocol ALifeValueShuffler <NSObject>
- (id)shuffle:(NSDictionary *)options;
- (id)shuffleWithMin:(NSNumber *)min max:(NSNumber *)max;
@end
