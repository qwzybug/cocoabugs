//
//  main.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#include "headless_main.m"

int main(int argc, char *argv[])
{
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSString *exec = [[NSString stringWithFormat:@"%s", argv[0]] lastPathComponent];
//	NSLog(exec);
//	if ([exec isEqual:@"CocoaBugs"]) {
		return NSApplicationMain(argc, (const char **) argv);
//	} else {
//		return headless_main(argc, argv);
//	}
//	[pool release];
}
