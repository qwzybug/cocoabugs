//
//  ALifePluginLoader.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ALifePluginLoader.h"

@implementation ALifePluginLoader

+ (NSMutableArray *)allPlugIns;
{
	NSBundle *currBundle;
	Class currPrincipalClass;
	
	NSMutableArray *plugIns = [NSMutableArray array];
	for (NSString *plugInPath in [self allPlugInPaths]) {
		currBundle = [NSBundle bundleWithPath:plugInPath];
        if (currBundle) {
            currPrincipalClass = [currBundle principalClass];
            if(currPrincipalClass && [self plugInClassIsValid:currPrincipalClass])  // Validation
            {
				[plugIns addObject:currPrincipalClass];
            }
        }
	}
	
	NSSortDescriptor *nameSort = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
	[plugIns sortUsingDescriptors:[NSArray arrayWithObjects:nameSort, nil]];
	
	return plugIns;
}

+ (BOOL)plugInClassIsValid:(Class)plugInClass;
{
	return [plugInClass conformsToProtocol:@protocol(ALifeController)];
}

+ (NSMutableArray *)allPlugInPaths;
{
	NSString *ext = @"plugin";
	NSString *appSupportSubpath = @"Application Support/CocoaBugs/PlugIns";
	
	NSArray *librarySearchPaths;
    NSMutableArray *bundleSearchPaths = [NSMutableArray array];
    NSMutableArray *allBundles = [NSMutableArray array];
	
	// find the libraries
    librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
	
	// we'll look in the App Support/CocoaBugs/PlugIns directory in each library
	for (NSString *currPath in librarySearchPaths) {
        [bundleSearchPaths addObject:[currPath stringByAppendingPathComponent:appSupportSubpath]];
	}
	[bundleSearchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
	
	// check for .plugin files
	for (NSString *currPath in bundleSearchPaths) {
		for (NSString *currBundlePath in [[NSFileManager defaultManager] directoryContentsAtPath:currPath]) {
			if ([[currBundlePath pathExtension] isEqualToString:ext]) {
				[allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
			}
		}
	}
	
    return allBundles;	
}

@end
