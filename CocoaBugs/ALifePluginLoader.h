//
//  ALifePluginLoader.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALifePluginLoader : NSObject {

}

+ (BOOL)plugInClassIsValid:(Class)plugInClass;
+ (NSMutableArray *)allPlugIns;
+ (NSMutableArray *)allPlugInPaths;

@end
