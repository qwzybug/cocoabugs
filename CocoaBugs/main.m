//
//  main.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "headless_main.m"

int main(int argc, char *argv[])
{
	if (argc < 2) {
		return NSApplicationMain(argc, (const char **) argv);
	} else {
		return headless_main(argc, argv);
	}
}
