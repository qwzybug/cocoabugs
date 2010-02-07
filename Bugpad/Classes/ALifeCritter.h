//
//  ALifeCritter.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ALifeCritter : NSObject {
	int x;
	int y;
}

@property (nonatomic, readonly) int x;
@property (nonatomic, readonly) int y;

- (UIColor *)color;

@end
