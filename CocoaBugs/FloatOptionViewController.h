//
//  FloatOptionViewController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 7/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FloatOptionViewController : NSViewController {
	IBOutlet NSSlider *slider;
	
	NSString *name;
	NSString *title;
	
	float minValue;
	float maxValue;
	float defaultValue;
	
	NSNumber *value;
}

@property (nonatomic, retain) IBOutlet NSSlider *slider;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, retain) NSNumber *value;

+ (FloatOptionViewController *)controllerWithOptions:(NSDictionary *)options;
- (id)initWithOptionDictionary:(NSDictionary *)options;

@end
