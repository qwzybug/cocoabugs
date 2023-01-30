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
	
	NSArray *builtInImages;
	int selectedImageIndex;
	
	NSImage *image;
}

@property(readwrite, strong) NSString *name;
@property(readwrite, strong) NSString *title;
@property(readonly) NSArray *builtInImages;
@property(readwrite, assign) int selectedImageIndex;

@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSImage *image;

- (NSData *)value;

+ (BitmapOptionViewController *)controllerWithOptions:(NSDictionary *)options;
- (id)initWithOptionDictionary:(NSDictionary *)options;

@end
