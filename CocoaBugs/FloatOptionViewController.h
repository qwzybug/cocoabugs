//
//  FloatOptionViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FloatOptionViewController : NSViewController {
	IBOutlet NSTextField *titleField;
	IBOutlet NSSlider *slider;
	
	IBOutlet NSTextField *currentValueField;
	IBOutlet NSTextField *minValueField;
	IBOutlet NSTextField *maxValueField;
	
	IBOutlet NSButton *shuffleButton;
	BOOL shuffling;
	IBOutlet NSTextField *plusMinusLabel;
	IBOutlet NSTextField *shuffleLabel;
	IBOutlet NSSlider *shuffleDial;
	float delta;
	
	NSString *name;
	NSString *title;
	
	float minValue;
	float maxValue;
	float defaultValue;
}

@property(readwrite, retain) NSString *name;
@property(readwrite, retain) NSString *title;
@property(readwrite, assign) BOOL shuffling;
@property(readwrite, assign) float delta;

+ (FloatOptionViewController *)controllerWithOptions:(NSDictionary *)options;
- (id)initWithOptionDictionary:(NSDictionary *)options;

- (NSNumber *)value;

- (IBAction)sliderValueChanged:(id)sender;

@end
