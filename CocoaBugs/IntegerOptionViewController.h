//
//  OptionViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IntegerOptionViewController : NSViewController {
	IBOutlet NSSlider *slider;
	
	NSString *name;
	NSString *title;
	
	int minValue;
	int maxValue;
	int ticks;
	int defaultValue;
	
	NSNumber *value;
}

@property (nonatomic, strong) IBOutlet NSSlider *slider;
@property(readwrite, strong) NSString *name;

@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int maxValue;

@property (nonatomic, strong) NSNumber *value;

+ (IntegerOptionViewController *)controllerWithOptions:(NSDictionary *)options;
- (id)initWithOptionDictionary:(NSDictionary *)options;

@end
