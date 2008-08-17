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

+ shuffleType:(NSString *)type withOptions:(NSDictionary *)options;

@end

@protocol ALifeValueShuffler <NSObject>
- (id)shuffle:(NSDictionary *)options;
@end
