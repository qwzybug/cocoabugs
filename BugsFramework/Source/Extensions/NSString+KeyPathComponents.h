//
//  NSString+KeyPathComponents.h
//  BugsFramework
//
//  Created by Devin Chalmers on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (KeyPathComponents)

- (NSString *)lastKeyPathComponent;
- (NSString *)majorKeyPath;

@end
