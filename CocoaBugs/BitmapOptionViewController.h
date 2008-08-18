//
//  BitmapOptionViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BitmapOptionViewController : NSViewController {
	NSString *name;
	NSString *title;
	
	int width;
	int height;
	
	IBOutlet NSTextField *titleField;
	IBOutlet NSImageView *imageView;
	IBOutlet NSTextField *widthHeightField;
	
	BOOL shuffling;
}

@property(readwrite, retain) NSString *name;
@property(readwrite, retain) NSString *title;
@property(readwrite, assign) BOOL shuffling;

- (NSData *)value;

+ (BitmapOptionViewController *)controllerWithOptions:(NSDictionary *)options;
- (id)initWithOptionDictionary:(NSDictionary *)options;

@end
